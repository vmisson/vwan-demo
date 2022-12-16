variable "location" {
  type = string
}

variable "dc-name" {
  type = string
}

variable "dc-shortname" {
  type = string
}

variable "onprem-address-space" {
  type = string
}

variable "azure_vpn_gateway_primary_pip" {
  type = string
}

variable "azure_vpn_gateway_primary_bgp" {
  type = string
}

variable "shared_key" {
  type = string
}

variable "asn" {
  type    = number
  default = 65002
}

variable "remote_asn" {
  type    = number
  default = 65515
}