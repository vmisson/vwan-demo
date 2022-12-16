variable "virtual_hub_express_route_gateway_name" {
  type        = string
  description = "(Required) The name of the ExpressRoute gateway. Changing this forces a new resource to be created."
}

variable "virtual_hub_express_route_gateway_resource_group" {
  type        = string
  description = "(Required) The name of the resource group in which to create the ExpressRoute gateway. Changing this forces a new resource to be created."
}

variable "virtual_hub_express_route_gateway_location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "virtual_hub_express_route_gateway_virtual_hub_id" {
  type        = string
  description = "(Required) The ID of a Virtual HUB within which the ExpressRoute gateway should be created."
}

variable "virtual_hub_express_route_gateway_scale_units" {
  type        = string
  description = "(Required) The number of scale units with which to provision the ExpressRoute gateway. Each scale unit is equal to 2Gbps, with support for up to 10 scale units (20Gbps)."
  default     = "1"
}

variable "virtual_hub_express_route_gateway_tags" {
  type    = map(string)
  default = {}
}

// Express Route - Connection
variable "virtual_hub_express_route_connection_name" {
  type        = string
  description = "(Required) The name which should be used for this Express Route Connection. Changing this forces a new resource to be created."
}

variable "virtual_hub_express_route_circuit_peering" {
  type        = string
  description = "Name of the circuit to connect"

}

variable "virtual_hub_express_route_connection_authorization_key" {
  type        = string
  description = "(Optional) The authorization key to establish the Express Route Connection."
  default     = null
}

variable "virtual_hub_express_route_connection_enable_internet_security" {
  type        = bool
  description = "(Optional) Is Internet security enabled for this Express Route Connection?"
  default     = null
}

variable "virtual_hub_express_route_connection_routing_associated_route_table_id" {
  type        = string
  description = "(Optional) The ID of the Virtual Hub Route Table associated with this Express Route Connection."
  default     = null
}

variable "virtual_hub_express_route_connection_routing_propagated_route_table_labels" {
  type        = list(string)
  description = "(Optional) The list of labels to logically group route tables."
  default     = ["default"]
}

variable "virtual_hub_express_route_connection_routing_propagated_route_table_route_table_ids" {
  type        = list(any)
  description = "(Optional) A list of IDs of the Virtual Hub Route Table to propagate routes from Express Route Connection to the route table."
  default     = []
}

variable "virtual_hub_express_route_connection_routing_weight" {
  type        = string
  description = "(Optional) The routing weight associated to the Express Route Connection. Possible value is between 0 and 32000. Defaults to 0."
  default     = "0"
}
