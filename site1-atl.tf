locals {
  atl-location     = "East US2"
  atl-dc-name      = "atlanta"
  atl-dc-shortname = "atl"
  atl-azure-asn    = 65010
  atl-onprem-asn   = 65011
}

module "azure_atl" {
  source                          = "./modules/datacenter/azure"
  location                        = local.atl-location
  virtual_wan_id                  = module.vwan.virtual-wan-id
  virtual_hub_resource_group_name = module.vwan_resource_group.resource-group-name
  vhub-address-prefix             = "10.110.0.0/23"
  dc-name                         = local.atl-dc-name
  dc-shortname                    = local.atl-dc-shortname
  azure-local-asn                 = local.atl-azure-asn
  hub-address-space               = "10.110.2.0/24"
  spoke1-address-space            = "10.110.3.0/24"
  spoke2-address-space            = "10.110.4.0/24"
  firewall_vm_name                = "atl-paloalto001"
}

module "onprem_atl" {
  source                        = "./modules/datacenter/onprem"
  location                      = local.atl-location
  dc-name                       = local.atl-dc-name
  dc-shortname                  = local.atl-dc-shortname
  onprem-address-space          = "10.10.0.0/24"
  azure_vpn_gateway_primary_pip = module.azure_atl.azurerm_vpn_gateway_primary_pip
  azure_vpn_gateway_primary_bgp = module.azure_atl.azurerm_vpn_gateway_primary_bgp
  shared_key                    = random_string.vpn-psk.result
  asn                           = local.atl-onprem-asn
}

resource "azurerm_vpn_site" "vpn-site-atl" {
  name                = "OnPrem-Atlanta"
  resource_group_name = module.vwan_resource_group.resource-group-name
  location            = local.atl-location
  virtual_wan_id      = module.vwan.virtual-wan-id

  link {
    name       = "atlgw001"
    ip_address = module.onprem_atl.azurerm_vpn_gateway_primary_pip
    bgp {
      asn             = local.atl-onprem-asn
      peering_address = module.onprem_atl.azurerm_vpn_gateway_primary_bgp
    }
  }
}

resource "azurerm_vpn_gateway_connection" "vpn-connection-atl" {
  name               = "vpn-connection-atl"
  vpn_gateway_id     = module.azure_atl.azurerm_vpn_gateway_id
  remote_vpn_site_id = azurerm_vpn_site.vpn-site-atl.id

  vpn_link {
    name             = "atlgw001-pip"
    vpn_site_link_id = azurerm_vpn_site.vpn-site-atl.link[0].id
    shared_key       = random_string.vpn-psk.result
    bgp_enabled      = true
  }
}