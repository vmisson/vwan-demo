output "vm_password" {
  value     = local.admin_password
  sensitive = true
}

output "private_ip_address" {
  value = azurerm_network_interface.network-interface.private_ip_address
}

output "network_interface_id" {
  value = azurerm_network_interface.network-interface.id
}
