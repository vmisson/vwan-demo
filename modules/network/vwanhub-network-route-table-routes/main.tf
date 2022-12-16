resource "azurerm_virtual_hub_route_table_route" "main" {
  for_each       = var.effective_routes
  route_table_id = var.route_table_id

  name              = each.value.name
  destinations_type = each.value.destinations_type
  destinations      = each.value.destinations
  next_hop_type     = each.value.next_hop_type
  next_hop          = each.value.next_hop
}