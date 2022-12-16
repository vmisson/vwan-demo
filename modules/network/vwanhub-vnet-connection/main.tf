locals {
  vwan_hub_name    = split("/", var.vwan_hub_id)[8]
  remote_vnet_name = split("/", var.spoke_vnet_id)[8]
}

resource "azurerm_virtual_hub_connection" "virtual-network-peering" {
  name                      = "${local.remote_vnet_name}-to-${local.vwan_hub_name}"
  virtual_hub_id            = var.vwan_hub_id
  remote_virtual_network_id = var.spoke_vnet_id
  internet_security_enabled = var.internet_security_enabled
  routing {
    associated_route_table_id = var.routing.associated_route_table_id

    dynamic "propagated_route_table" {
      for_each = lookup(var.routing, "propagated_routes", [])
      content {
        labels          = lookup(propagated_route_table.value, "labels", "${var.vwan_hub_id}/hubRouteTables/noneRouteTable")
        route_table_ids = lookup(propagated_route_table.value, "route_table_ids", "${var.vwan_hub_id}/hubRouteTables/noneRouteTable")
      }
    }

    dynamic "static_vnet_route" {
      for_each = lookup(var.routing, "static_vnet_routes", [])
      content {
        name                = lookup(static_vnet_route.value, "name", null)
        address_prefixes    = lookup(static_vnet_route.value, "address_prefixes", null)
        next_hop_ip_address = lookup(static_vnet_route.value, "next_hop_ip_address", null)
      }
    }
  }
}
