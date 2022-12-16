variable "virtual_network_name" {
  type = string
}

variable "virtual_network_location" {
  type = string
}

variable "virtual_network_resource_group_name" {
  type = string
}

variable "virtual_network_address_space" {
  type = list(string)
}

variable "virtual_network_locked" {
  type    = bool
  default = true
}

variable "virtual_network_peering_with_inf" {
  description = "Peer the vnet with the regional inf VN"
  type        = bool
  default     = true
}

variable "virtual_network_address_dns_servers" {
  type    = list(string)
  default = []
}

variable "virtual_network_tags" {
  type    = map(string)
  default = {}
}

variable "subnet" {
  type = map(object({
    address_prefixes                               = list(string)
    delegation                                     = optional(string)
    nsg_anr_managed                                = optional(bool)
    enforce_private_link_endpoint_network_policies = optional(bool)
    service_endpoints                              = optional(list(string))
  }))
  default = {}
}

variable "peering_name" {
  type    = string
  default = ""
}

variable "remote_peering_name" {
  type    = string
  default = ""
}

variable "peering_allow_forwarded_traffic" {
  type    = bool
  default = true
}

variable "remote_peering_allow_forwarded_traffic" {
  type    = bool
  default = true
}

variable "vwan_peering" {
  type    = bool
  default = false
}

variable "routing" {
  type = object({
    associated_route_table_id = string
    propagated_routes = list(object({
      labels          = list(string)
      route_table_ids = list(string)
    }))
    static_vnet_routes = list(object({
      name                = string
      address_prefixes    = list(string)
      next_hop_ip_address = string
    }))
  })
  default = {
    associated_route_table_id = null,
    propagated_routes         = null,
    static_vnet_routes        = null
  }
}