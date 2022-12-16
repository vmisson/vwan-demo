module "azure_resource_group" {
  source                  = "../../resourcegroup"
  resource_group_name     = "onprem-${var.dc-name}"
  resource_group_location = var.location
}

module "onprem_vnet" {
  source                              = "../../network/virtual-network"
  virtual_network_name                = "azure-${var.dc-shortname}-onprem01"
  virtual_network_location            = module.azure_resource_group.resource-group-location
  virtual_network_resource_group_name = module.azure_resource_group.resource-group-name
  virtual_network_address_space       = [var.onprem-address-space]
}

module "onprem_subnet_gateway" {
  source                          = "../../network/subnet"
  subnet_name                     = "GatewaySubnet"
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.onprem_vnet.name
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_address_prefixes         = [cidrsubnet(var.onprem-address-space, 2, 0)]
}

module "onprem_subnet_workload" {
  source                          = "../../network/subnet"
  subnet_name                     = "snet-workload"
  subnet_resource_group_name      = module.azure_resource_group.resource-group-name
  subnet_virtual_network_name     = module.onprem_vnet.name
  subnet_virtual_network_location = module.azure_resource_group.resource-group-location
  subnet_address_prefixes         = [cidrsubnet(var.onprem-address-space, 2, 1)]
}

resource "azurerm_public_ip" "gateway_pip" {
  name                = "${var.dc-shortname}gw001-pip"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = ["1", "2", "3"]
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                = "${var.dc-shortname}gw001"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1AZ"

  bgp_settings {
    asn = var.asn
  }

  ip_configuration {
    name                          = "gw-ip1"
    public_ip_address_id          = azurerm_public_ip.gateway_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.onprem_subnet_gateway.subnet_id
  }
}

resource "azurerm_local_network_gateway" "local_network_gateway_vwan" {
  name                = "vhub-${var.dc-shortname}-0001-lng"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name
  gateway_address     = var.azure_vpn_gateway_primary_pip

  bgp_settings {
    asn                 = var.remote_asn
    bgp_peering_address = var.azure_vpn_gateway_primary_bgp
  }
}


resource "azurerm_virtual_network_gateway_connection" "connection_onprem-primary" {
  name                = "onprem-primary"
  location            = module.azure_resource_group.resource-group-location
  resource_group_name = module.azure_resource_group.resource-group-name

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway_vwan.id
  shared_key                 = var.shared_key
}

module "onprem_vm" {
  source                              = "../../compute/virtualmachine/linux"
  resource_group_name                 = module.azure_resource_group.resource-group-name
  resource_group_location             = module.azure_resource_group.resource-group-location
  vm_name                             = "onprem-vm"
  virtual_network_name                = module.onprem_vnet.id
  virtual_network_resource_group_name = module.azure_resource_group.resource-group-name
  subnet_id                           = module.onprem_subnet_workload.subnet_id
  admin_password                      = "Microsoft=1"
}