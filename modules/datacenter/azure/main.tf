###########################
# Virtual Hub
###########################
module "vwan-vhub" {
  source                          = "../../network/virtual-hub"
  virtual_hub_name                = "vhub-${var.dc-shortname}"
  virtual_hub_resource_group_name = var.virtual_hub_resource_group_name
  virtual_hub_virtual_wan_id      = var.virtual_wan_id
  virtual_hub_location            = var.location
  virtual_hub_address_prefix      = var.vhub-address-prefix
}

module "azure_resource_group" {
  source                  = "../../resourcegroup"
  resource_group_name     = "azure-${var.dc-name}"
  resource_group_location = var.location
}

module "azure_vnet_spoke01" {
  source                              = "../../network/virtual-network"
  virtual_network_name                = "azure-${var.dc-shortname}-spoke01"
  virtual_network_location            = module.azure_resource_group.resource-group-location
  virtual_network_resource_group_name = module.azure_resource_group.resource-group-name
  virtual_network_address_space       = [var.spoke1-address-space]
}

module "azure_subnet_workload_spoke01" {
  source                          = "../../network/subnet"
  subnet_name                     = "snet-workload"
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.azure_vnet_spoke01.name
  subnet_address_prefixes         = [var.spoke1-address-space]
}

module "azure_subnet_peering_spoke01_infra" {
  source                                              = "../../network/virtual-network-peering"
  virtual_network_peering_resource_group_name         = module.azure_resource_group.resource-group-name
  virtual_network_peering_virtual_network_name        = module.azure_vnet_spoke01.name
  virtual_network_peering_remote_virtual_network_name = module.azure_vnet_hub.name
  virtual_network_peering_remote_virtual_network_id   = module.azure_vnet_hub.id
}

module "azure_subnet_peering_infra_spoke01" {
  source                                              = "../../network/virtual-network-peering"
  virtual_network_peering_resource_group_name         = module.azure_resource_group.resource-group-name
  virtual_network_peering_virtual_network_name        = module.azure_vnet_hub.name
  virtual_network_peering_remote_virtual_network_name = module.azure_vnet_spoke01.name
  virtual_network_peering_remote_virtual_network_id   = module.azure_vnet_spoke01.id
}

module "azure_vnet_spoke02" {
  source                              = "../../network/virtual-network"
  virtual_network_name                = "azure-${var.dc-shortname}-spoke02"
  virtual_network_location            = module.azure_resource_group.resource-group-location
  virtual_network_resource_group_name = module.azure_resource_group.resource-group-name
  virtual_network_address_space       = [var.spoke2-address-space]
}

module "azure_subnet_workload_spoke02" {
  source                          = "../../network/subnet"
  subnet_name                     = "snet-workload"
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.azure_vnet_spoke02.name
  subnet_address_prefixes         = [var.spoke2-address-space]
}

module "azure_subnet_peering_spoke02_infra" {
  source                                              = "../../network/virtual-network-peering"
  virtual_network_peering_resource_group_name         = module.azure_resource_group.resource-group-name
  virtual_network_peering_virtual_network_name        = module.azure_vnet_spoke02.name
  virtual_network_peering_remote_virtual_network_name = module.azure_vnet_hub.name
  virtual_network_peering_remote_virtual_network_id   = module.azure_vnet_hub.id
}

module "azure_subnet_peering_infra_spoke02" {
  source                                              = "../../network/virtual-network-peering"
  virtual_network_peering_resource_group_name         = module.azure_resource_group.resource-group-name
  virtual_network_peering_virtual_network_name        = module.azure_vnet_hub.name
  virtual_network_peering_remote_virtual_network_name = module.azure_vnet_spoke02.name
  virtual_network_peering_remote_virtual_network_id   = module.azure_vnet_spoke02.id
}

module "azure_vnet_hub" {
  source                              = "../../network/virtual-network"
  virtual_network_name                = "azure-${var.dc-shortname}-infra"
  virtual_network_location            = module.azure_resource_group.resource-group-location
  virtual_network_resource_group_name = module.azure_resource_group.resource-group-name
  virtual_network_address_space       = [var.hub-address-space]
}

module "azure_subnet_firewall-management" {
  source = "../../network/subnet"

  subnet_name                     = "snet-pan-management"
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.azure_vnet_hub.name
  subnet_address_prefixes         = [cidrsubnet(var.hub-address-space, 4, 0)]
}

module "azure_subnet_firewall-untrust" {
  source = "../../network/subnet"

  subnet_name                     = "snet-pan-untrust"
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.azure_vnet_hub.name
  subnet_address_prefixes         = [cidrsubnet(var.hub-address-space, 4, 1)]
}

module "azure_subnet_firewall-trust" {
  source = "../../network/subnet"

  subnet_name                     = "snet-pan-trust"
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.azure_vnet_hub.name
  subnet_address_prefixes         = [cidrsubnet(var.hub-address-space, 4, 2)]
}

module "azure_subnet_dns-inbound" {
  source = "../../network/subnet"

  subnet_name                     = "snet-dnsinfra-inbound"
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.azure_vnet_hub.name
  subnet_address_prefixes         = [cidrsubnet(var.hub-address-space, 2, 2)]
}

module "azure_subnet_dns-outbound" {
  source = "../../network/subnet"

  subnet_name                     = "snet-dnsinfra-outbound"
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.azure_vnet_hub.name
  subnet_address_prefixes         = [cidrsubnet(var.hub-address-space, 2, 3)]
}

module "azure_vnet_hub-vwan-connection" {
  source        = "../../network/vwanhub-vnet-connection"
  spoke_vnet_id = module.azure_vnet_hub.id
  vwan_hub_id   = module.vwan-vhub.virtual-hub-id
  routing = {
    associated_route_table_id = "${module.vwan-vhub.virtual-hub-id}/hubRouteTables/defaultRouteTable"
    propagated_routes = [
      {
        route_table_ids = []
        labels          = ["default"]
      }
    ]
    static_vnet_routes = []
  }
}

resource "azurerm_route_table" "spoke-rt" {
  name                = "${var.dc-shortname}-spoke-rt"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
}

resource "azurerm_route" "default-route" {
  name                   = "DefaultToFirewall"
  resource_group_name    = module.azure_resource_group.resource-group-name
  route_table_name       = azurerm_route_table.spoke-rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = cidrhost(cidrsubnet(var.hub-address-space, 4, 2), 4)
}

resource "azurerm_subnet_route_table_association" "subnet_rt_association_spoke1" {
  subnet_id      = module.azure_subnet_workload_spoke01.subnet_id
  route_table_id = azurerm_route_table.spoke-rt.id
}

resource "azurerm_subnet_route_table_association" "subnet_rt_association_spoke2" {
  subnet_id      = module.azure_subnet_workload_spoke02.subnet_id
  route_table_id = azurerm_route_table.spoke-rt.id
}

module "azure_vm" {
  source                              = "../../compute/virtualmachine/linux"
  resource_group_name                 = module.azure_resource_group.resource-group-name
  resource_group_location             = module.azure_resource_group.resource-group-location
  vm_name                             = "azure-spoke1-vm"
  virtual_network_name                = module.azure_vnet_spoke01.id
  virtual_network_resource_group_name = module.azure_resource_group.resource-group-name
  subnet_id                           = module.azure_subnet_workload_spoke01.subnet_id
  admin_password                      = "Microsoft=1"
}

module "azure_vm2" {
  source                              = "../../compute/virtualmachine/linux"
  resource_group_name                 = module.azure_resource_group.resource-group-name
  resource_group_location             = module.azure_resource_group.resource-group-location
  vm_name                             = "azure-spoke2-vm"
  virtual_network_name                = module.azure_vnet_spoke02.id
  virtual_network_resource_group_name = module.azure_resource_group.resource-group-name
  subnet_id                           = module.azure_subnet_workload_spoke02.subnet_id
  admin_password                      = "Microsoft=1"
}

#######################################################
#######################################################
#######################################################

locals {
  bootstrap_file = "${path.module}/files/bootstrap.tftpl"
  init-cfg_file  = "${path.module}/files/init-cfg.tftpl"
}

# Create public IPs for the Internet-facing data interfaces so they could talk outbound.
resource "azurerm_public_ip" "fw-public" {
  name                = "${var.firewall_vm_name}-public"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["2"]
}

resource "azurerm_public_ip" "fw-mgmt" {
  name                = "${var.firewall_vm_name}-mgmt"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["2"]
  domain_name_label   = "${var.firewall_vm_name}-mgmt"
}

resource "azurerm_network_security_group" "nsg-mgmt" {
  name                = "sg-mgmt"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
}

resource "azurerm_network_security_group" "nsg-public" {
  name                = "sg-public"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
}

# Allow inbound access to Management subnet.
resource "azurerm_network_security_rule" "mgmt" {
  name                        = "vmseries-mgmt-allow-inbound"
  resource_group_name         = module.azure_resource_group.resource-group-name
  network_security_group_name = azurerm_network_security_group.nsg-mgmt.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 1000
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes     = var.allow_inbound_mgmt_ips
  destination_address_prefix  = "*"
  destination_port_range      = "*"
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association-mgmt" {
  subnet_id                 = module.azure_subnet_firewall-management.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg-mgmt.id
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association_public" {
  subnet_id                 = module.azure_subnet_firewall-untrust.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg-public.id
}

# The storage account for VM-Series initialization.
resource "random_integer" "id" {
  min = 100
  max = 999
}

resource "local_file" "init-cfg" {
  content  = templatefile(local.init-cfg_file, { dc-shortname = var.dc-shortname })
  filename = "${path.module}/generated-files/init-cfg-${var.dc-shortname}.txt"
}

resource "local_file" "bootstrap" {
  content  = templatefile(local.bootstrap_file, { azure-local-asn = var.azure-local-asn, dc-ipprefix = join(".", [split(".", var.hub-address-space)[0], split(".", var.hub-address-space)[1]]) })
  filename = "${path.module}/generated-files/bootstrap-${var.dc-shortname}.xml"
}

module "bootstrap" {
  source = "../../paloalto/bootstrap"

  location             = module.azure_resource_group.resource-group-location
  resource_group_name  = module.azure_resource_group.resource-group-name
  storage_account_name = "${var.dc-shortname}paloaltobootstrap${random_integer.id.result}"
  storage_share_name   = "${var.dc-shortname}sharepaloaltobootstrap${random_integer.id.result}"
  files = {
    "${path.module}/generated-files/init-cfg-${var.dc-shortname}.txt"  = "config/init-cfg.txt"
    "${path.module}/generated-files/bootstrap-${var.dc-shortname}.xml" = "config/bootstrap.xml"
  }
  files_md5 = {
    "${path.module}/generated-files/init-cfg-${var.dc-shortname}.txt"  = md5(local_file.init-cfg.content)
    "${path.module}/generated-files/bootstrap-${var.dc-shortname}.xml" = md5(local_file.bootstrap.content)
  }
}

module "paloalto_vmseries" {
  source              = "../../paloalto/vmseries"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
  name                = var.firewall_vm_name
  username            = var.username
  password            = var.password
  img_version         = var.common_vmseries_version
  img_sku             = var.common_vmseries_sku
  #vm_size             = "Standard_D8s_v3"
  enable_zones = var.enable_zones
  avzone       = "2"
  bootstrap_options = (join(",",
    [
      "storage-account=${module.bootstrap.storage_account.name}",
      "access-key=${module.bootstrap.storage_account.primary_access_key}",
      "file-share=${module.bootstrap.storage_share.name}",
      "share-directory=None"
    ]
  ))
  interfaces = [
    {
      name                 = "${var.firewall_vm_name}-mgmt"
      subnet_id            = module.azure_subnet_firewall-management.subnet_id
      public_ip_address_id = azurerm_public_ip.fw-mgmt.id
    },
    {
      name                 = "${var.firewall_vm_name}-public"
      subnet_id            = module.azure_subnet_firewall-untrust.subnet_id
      public_ip_address_id = azurerm_public_ip.fw-public.id
    },
    {
      name      = "${var.firewall_vm_name}-private"
      subnet_id = module.azure_subnet_firewall-trust.subnet_id
    },
  ]
  depends_on = [module.bootstrap]
}

resource "azapi_resource" "vhub_bgp_connection_fw" {
  type      = "Microsoft.Network/virtualHubs/bgpConnections@2022-01-01"
  name      = "vhub_bgp_connection_fw"
  parent_id = module.vwan-vhub.virtual-hub-id

  body = jsonencode({
    properties = {
      hubVirtualNetworkConnection = {
        id = module.azure_vnet_hub-vwan-connection.vnet_peering_id
      }
      peerAsn = 65012
      peerIp  = cidrhost(cidrsubnet(var.hub-address-space, 4, 2), 4)
    }
  })
}

module "vwan-vhub-vpn-gateway" {
  source = "../../network/vwanhub-vpn-gateway"

  // VPN Gateway
  virtual_hub_vpn_gateway_name           = "${module.vwan-vhub.virtual-hub-name}-vpn-gateway"
  virtual_hub_vpn_gateway_resource_group = var.virtual_hub_resource_group_name
  virtual_hub_vpn_gateway_location       = module.vwan-vhub.virtual-hub-location
  virtual_hub_vpn_gateway_virtual_hub_id = module.vwan-vhub.virtual-hub-id
}

# resource "azurerm_vpn_gateway_connection" "vpn-connection-atl" {
#   name               = "vpn-connection-atl"
#   vpn_gateway_id     = module.vwan-vhub-atl-vpn-gateway.azurerm_vpn_gateway_id
#   remote_vpn_site_id = azurerm_vpn_site.vpn-site-atl.id

#   vpn_link {
#     name             = "eusgw001-pip"
#     vpn_site_link_id = azurerm_vpn_site.vpn-site-atl.link[0].id
#     shared_key       = random_string.vpn-psk.result
#     bgp_enabled      = true
#   }
# }