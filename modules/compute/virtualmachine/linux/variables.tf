variable "virtualmachine_linux_tags" {
  type    = map(string)
  default = {}
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "zone" {
  type    = number
  default = null
}

variable "storage_account_blob_endpoint" {
  type    = string
  default = null
}

variable "storage_account_resource_group_name" {
  type    = string
  default = ""
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type    = string
  default = ""
}

variable "os_disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "os_disk_size" {
  type    = number
  default = 30
}

variable "virtual_network_name" {
  type = string
}
variable "virtual_network_resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "run_bootstrap" {
  type    = bool
  default = true
}