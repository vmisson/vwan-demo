output "azurerm_vpn_gateway_id" {
  value = azurerm_vpn_gateway.vpn_gateway.id
}

output "azurerm_vpn_gateway_primary_pip" {
  value = sort(azurerm_vpn_gateway.vpn_gateway.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[1]
}

output "azurerm_vpn_gateway_secondary_pip" {
  value = sort(azurerm_vpn_gateway.vpn_gateway.bgp_settings[0].instance_1_bgp_peering_address[0].tunnel_ips)[1]
}

output "azurerm_vpn_gateway_primary_bgp" {
  value = sort(azurerm_vpn_gateway.vpn_gateway.bgp_settings[0].instance_0_bgp_peering_address[0].default_ips)[0]
}

output "azurerm_vpn_gateway_secondary_bgp" {
  value = sort(azurerm_vpn_gateway.vpn_gateway.bgp_settings[0].instance_1_bgp_peering_address[0].default_ips)[0]
}