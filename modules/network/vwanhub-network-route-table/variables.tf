variable "route_table_name" {
  type = string
}

variable "vwan_hub_id" {
  type = string
}

variable "labels" {
  type    = list(any)
  default = []
}