output "azurerm_vpn_gateway_primary_pip" {
  value = azurerm_public_ip.gateway_pip.ip_address
}

output "azurerm_vpn_gateway_primary_bgp" {
  value = azurerm_virtual_network_gateway.gateway.bgp_settings[0].peering_addresses[0].default_addresses[0]
}
