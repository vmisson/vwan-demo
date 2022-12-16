output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "subnet_virtual_network_name" {
  value = azurerm_subnet.subnet.virtual_network_name
}
