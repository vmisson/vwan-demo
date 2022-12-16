locals {
  sas-location     = "Southeast Asia"
  sas-dc-name      = "singapore"
  sas-dc-shortname = "sas"
  sas-azure-asn    = 65030
  sas-onprem-asn   = 65031
}

module "azure_sas" {
  source                          = "./modules/datacenter/azure"
  location                        = local.sas-location
  virtual_wan_id                  = module.vwan.virtual-wan-id
  virtual_hub_resource_group_name = module.vwan_resource_group.resource-group-name
  vhub-address-prefix             = "10.130.0.0/23"
  dc-name                         = local.sas-dc-name
  dc-shortname                    = local.sas-dc-shortname
  azure-local-asn                 = local.sas-azure-asn
  hub-address-space               = "10.130.2.0/24"
  spoke1-address-space            = "10.130.3.0/24"
  spoke2-address-space            = "10.130.4.0/24"
  firewall_vm_name                = "sas-paloalto001"
}

module "onprem_sas" {
  source                        = "./modules/datacenter/onprem"
  location                      = local.sas-location
  dc-name                       = local.sas-dc-name
  dc-shortname                  = local.sas-dc-shortname
  onprem-address-space          = "10.30.0.0/24"
  azure_vpn_gateway_primary_pip = module.azure_sas.azurerm_vpn_gateway_primary_pip
  azure_vpn_gateway_primary_bgp = module.azure_sas.azurerm_vpn_gateway_primary_bgp
  shared_key                    = random_string.vpn-psk.result
  asn                           = local.sas-onprem-asn
}

resource "azurerm_vpn_site" "vpn-site-sas" {
  name                = "OnPrem-Singapore"
  resource_group_name = module.vwan_resource_group.resource-group-name
  location            = local.sas-location
  virtual_wan_id      = module.vwan.virtual-wan-id

  link {
    name       = "sasgw001"
    ip_address = module.onprem_sas.azurerm_vpn_gateway_primary_pip
    bgp {
      asn             = local.sas-onprem-asn
      peering_address = module.onprem_sas.azurerm_vpn_gateway_primary_bgp
    }
  }
}

resource "azurerm_vpn_gateway_connection" "vpn-connection-sas" {
  name               = "vpn-connection-sas"
  vpn_gateway_id     = module.azure_sas.azurerm_vpn_gateway_id
  remote_vpn_site_id = azurerm_vpn_site.vpn-site-sas.id

  vpn_link {
    name             = "sasgw001-pip"
    vpn_site_link_id = azurerm_vpn_site.vpn-site-sas.link[0].id
    shared_key       = random_string.vpn-psk.result
    bgp_enabled      = true
  }
}