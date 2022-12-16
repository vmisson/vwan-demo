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

variable "virtual_network_address_dns_servers" {
  type    = list(string)
  default = []
}

variable "virtual_network_tags" {
  type    = map(string)
  default = {}
}

variable "virtual_network_peering" {
  type    = bool
  default = false
}