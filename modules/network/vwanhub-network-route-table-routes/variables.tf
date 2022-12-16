variable "route_table_id" {
  type = string
}

variable "effective_routes" {
  type = map(object({
    name              = string
    destinations_type = string
    destinations      = list(string)
    next_hop_type     = string
    next_hop          = string
  }))
  description = "The route with their properties."
  default     = {}
}