variable "virtual_network_peering_resource_group_name" {
  type = string
}

variable "virtual_network_peering_virtual_network_name" {
  type = string
}

variable "virtual_network_peering_remote_virtual_network_name" {
  type = string
}

variable "virtual_network_peering_remote_virtual_network_id" {
  type = string
}

variable "virtual_network_peering_allow_forwarded_traffic" {
  type    = bool
  default = true
}

variable "virtual_network_peering_use_remote_gateways" {
  type    = bool
  default = false
}

variable "virtual_network_peering_allow_gateway_transit" {
  type    = bool
  default = false
}

variable "virtual_network_peering_name" {
  type    = string
  default = ""
}
