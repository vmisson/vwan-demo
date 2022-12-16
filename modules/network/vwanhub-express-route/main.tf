locals {
  virtual_hub_express_route_gateway_tags = merge(
    tomap({
      ManagedBy = "terraform/virtual-wan"
    }),
    var.virtual_hub_express_route_gateway_tags
  )
  express_route_peerings = {
  }
}

resource "azurerm_express_route_gateway" "express_route_gateway" {
  name                = var.virtual_hub_express_route_gateway_name
  resource_group_name = var.virtual_hub_express_route_gateway_resource_group
  location            = var.virtual_hub_express_route_gateway_location
  virtual_hub_id      = var.virtual_hub_express_route_gateway_virtual_hub_id
  scale_units         = var.virtual_hub_express_route_gateway_scale_units
  tags                = local.virtual_hub_express_route_gateway_tags
}

resource "azurerm_express_route_connection" "express_route_connection" {
  name                             = var.virtual_hub_express_route_connection_name
  express_route_gateway_id         = azurerm_express_route_gateway.express_route_gateway.id
  express_route_circuit_peering_id = local.express_route_peerings[var.virtual_hub_express_route_circuit_peering]
  authorization_key                = var.virtual_hub_express_route_connection_authorization_key
  enable_internet_security         = var.virtual_hub_express_route_connection_enable_internet_security
  routing {
    associated_route_table_id = var.virtual_hub_express_route_connection_routing_associated_route_table_id
    propagated_route_table {
      labels = var.virtual_hub_express_route_connection_routing_propagated_route_table_labels
      #route_table_ids = var.virtual_hub_express_route_connection_routing_propagated_route_table_route_table_ids
      route_table_ids = ["${var.virtual_hub_express_route_gateway_virtual_hub_id}/hubRouteTables/defaultRouteTable"]
    }
  }
  routing_weight = var.virtual_hub_express_route_connection_routing_weight
}
