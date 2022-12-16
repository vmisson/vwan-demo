locals {
  virtual_network_tags = merge(
    tomap({
      ManagedBy = "terraform/virtual-network"
    }),
    var.virtual_network_tags,
  )
}

resource "azurerm_virtual_network" "virtual-network" {
  name                = var.virtual_network_name
  location            = var.virtual_network_location
  resource_group_name = var.virtual_network_resource_group_name
  address_space       = var.virtual_network_address_space
  dns_servers         = var.virtual_network_address_dns_servers

  tags = local.virtual_network_tags
}
