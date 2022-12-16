resource "azurerm_virtual_network_peering" "virtual-network-peering" {
  name                      = coalesce(var.virtual_network_peering_name, "${var.virtual_network_peering_virtual_network_name}-to-${var.virtual_network_peering_remote_virtual_network_name}")
  resource_group_name       = var.virtual_network_peering_resource_group_name
  virtual_network_name      = var.virtual_network_peering_virtual_network_name
  remote_virtual_network_id = var.virtual_network_peering_remote_virtual_network_id
  allow_forwarded_traffic   = var.virtual_network_peering_allow_forwarded_traffic
  use_remote_gateways       = var.virtual_network_peering_use_remote_gateways
  allow_gateway_transit     = var.virtual_network_peering_allow_gateway_transit
}
