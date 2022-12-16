resource "azurerm_subnet" "subnet" {
  name                                      = var.subnet_name
  resource_group_name                       = var.subnet_resource_group_name
  virtual_network_name                      = var.subnet_virtual_network_name
  address_prefixes                          = var.subnet_address_prefixes
  private_endpoint_network_policies_enabled = var.subnet_private_endpoint_network_policies_enabled


  dynamic "delegation" {
    for_each = compact([var.subnet_delegation])
    content {
      name = var.subnet_delegation
      service_delegation {
        name = var.subnet_delegation
      }
    }
  }

  service_endpoints = var.subnet_service_endpoints

  lifecycle {
    ignore_changes = [
      delegation[0].service_delegation[0].actions,
    ]
  }
}

resource "azurerm_network_security_group" "network-security-group" {
  count               = var.subnet_nsg ? 1 : 0
  name                = "${var.subnet_virtual_network_name}-${azurerm_subnet.subnet.name}_nsg"
  resource_group_name = var.subnet_resource_group_name
  location            = var.subnet_virtual_network_location
}

resource "azurerm_subnet_network_security_group_association" "subnet-network-security-group-association" {
  count                     = var.subnet_nsg ? 1 : 0
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network-security-group[0].id
}