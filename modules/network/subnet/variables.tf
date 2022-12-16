variable "subnet_name" {
  type = string
}

variable "subnet_resource_group_name" {
  type = string
}

variable "subnet_virtual_network_name" {
  type = string
}

variable "subnet_address_prefixes" {
  type = list(string)
}

variable "subnet_virtual_network_location" {
  type = string
}

variable "subnet_delegation" {
  type    = string
  default = ""
}

variable "subnet_nsg" {
  type    = bool
  default = false
}

variable "subnet_service_endpoints" {
  type    = list(string)
  default = []
}

variable "subnet_private_endpoint_network_policies_enabled" {
  type    = bool
  default = false
}