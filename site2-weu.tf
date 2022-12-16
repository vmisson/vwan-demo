locals {
  weu-location     = "West Europe"
  weu-dc-name      = "amsterdam"
  weu-dc-shortname = "weu"
  weu-azure-asn    = 65020
  weu-onprem-asn   = 65021
}

module "azure_weu" {
  source                          = "./modules/datacenter/azure"
  location                        = local.weu-location
  virtual_wan_id                  = module.vwan.virtual-wan-id
  virtual_hub_resource_group_name = module.vwan_resource_group.resource-group-name
  vhub-address-prefix             = "10.120.0.0/23"
  dc-name                         = local.weu-dc-name
  dc-shortname                    = local.weu-dc-shortname
  azure-local-asn                 = local.weu-azure-asn
  hub-address-space               = "10.120.2.0/24"
  spoke1-address-space            = "10.120.3.0/24"
  spoke2-address-space            = "10.120.4.0/24"
  firewall_vm_name                = "weu-paloalto001"
}

module "onprem_weu" {
  source                        = "./modules/datacenter/onprem"
  location                      = local.weu-location
  dc-name                       = local.weu-dc-name
  dc-shortname                  = local.weu-dc-shortname
  onprem-address-space          = "10.20.0.0/24"
  azure_vpn_gateway_primary_pip = module.azure_weu.azurerm_vpn_gateway_primary_pip
  azure_vpn_gateway_primary_bgp = module.azure_weu.azurerm_vpn_gateway_primary_bgp
  shared_key                    = random_string.vpn-psk.result
  asn                           = local.weu-onprem-asn
}

resource "azurerm_vpn_site" "vpn-site-weu" {
  name                = "OnPrem-Amsterdam"
  resource_group_name = module.vwan_resource_group.resource-group-name
  location            = local.weu-location
  virtual_wan_id      = module.vwan.virtual-wan-id

  link {
    name       = "weugw001"
    ip_address = module.onprem_weu.azurerm_vpn_gateway_primary_pip
    bgp {
      asn             = local.weu-onprem-asn
      peering_address = module.onprem_weu.azurerm_vpn_gateway_primary_bgp
    }
  }
}

resource "azurerm_vpn_gateway_connection" "vpn-connection-weu" {
  name               = "vpn-connection-weu"
  vpn_gateway_id     = module.azure_weu.azurerm_vpn_gateway_id
  remote_vpn_site_id = azurerm_vpn_site.vpn-site-weu.id

  vpn_link {
    name             = "weugw001-pip"
    vpn_site_link_id = azurerm_vpn_site.vpn-site-weu.link[0].id
    shared_key       = random_string.vpn-psk.result
    bgp_enabled      = true
  }
}