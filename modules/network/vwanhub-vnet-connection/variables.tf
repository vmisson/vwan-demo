variable "spoke_vnet_id" {
  type = string
}

variable "vwan_hub_id" {
  type = string
}

variable "internet_security_enabled" {
  type    = bool
  default = true
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
}
