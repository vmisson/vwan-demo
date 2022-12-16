output "virtual-hub-id" {
  value = azurerm_virtual_hub.virtual-hub.id
}

output "virtual-hub-name" {
  value = azurerm_virtual_hub.virtual-hub.name
}

output "virtual-hub-location" {
  value = azurerm_virtual_hub.virtual-hub.location
}

output "firewall-id" {
  value = var.virtual_hub_secured ? azurerm_firewall.firewall[0].id : null
}
