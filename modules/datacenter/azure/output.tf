output "azurerm_vpn_gateway_id" {
  value = module.vwan-vhub-vpn-gateway.azurerm_vpn_gateway_id
}

output "azurerm_vpn_gateway_primary_pip" {
  value = module.vwan-vhub-vpn-gateway.azurerm_vpn_gateway_primary_pip
}

output "azurerm_vpn_gateway_primary_bgp" {
  value = module.vwan-vhub-vpn-gateway.azurerm_vpn_gateway_primary_bgp
}
