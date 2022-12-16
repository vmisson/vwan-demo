variable "virtual_hub_vpn_gateway_name" {
  type        = string
  description = "(Required) The name of the ExpressRoute gateway. Changing this forces a new resource to be created."
}

variable "virtual_hub_vpn_gateway_resource_group" {
  type        = string
  description = "(Required) The name of the resource group in which to create the ExpressRoute gateway. Changing this forces a new resource to be created."
}

variable "virtual_hub_vpn_gateway_location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "virtual_hub_vpn_gateway_virtual_hub_id" {
  type        = string
  description = "(Required) The ID of a Virtual HUB within which the ExpressRoute gateway should be created."
}

variable "virtual_hub_vpn_gateway_scale_unit" {
  type        = string
  description = "(Required) The number of scale units with which to provision the ExpressRoute gateway. Each scale unit is equal to 2Gbps, with support for up to 10 scale units (20Gbps)."
  default     = "1"
}

variable "virtual_hub_vpn_gateway_tags" {
  type    = map(string)
  default = {}
}