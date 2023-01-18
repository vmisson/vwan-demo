variable "location" {
  type = string
}

variable "virtual_wan_id" {
  type = string
}

variable "virtual_hub_resource_group_name" {
  type = string
}

variable "vhub-address-prefix" {
  type = string
}

variable "dc-name" {
  type = string
}

variable "dc-shortname" {
  type = string
}

variable "hub-address-space" {
  type = string
}

variable "spoke1-address-space" {
  type = string
}

variable "spoke2-address-space" {
  type = string
}

variable "azure-local-asn" {
  type = number
}

variable "firewall_vm_name" {
  type = string
}

variable "allow_inbound_mgmt_ips" {
  default = ["1.1.1.1", "2.2.2.2"]
  type    = list(string)

  validation {
    condition     = length(var.allow_inbound_mgmt_ips) > 0
    error_message = "At least one address has to be specified."
  }
}

variable "common_vmseries_sku" {
  description = "VM-Series SKU - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "byol"
  type        = string
}

variable "common_vmseries_version" {
  description = "VM-Series PAN-OS version - list available with `az vm image list -o table --all --publisher paloaltonetworks`"
  default     = "latest"
  #default     = "9.1.10"
  type = string
}

variable "common_vmseries_vm_size" {
  description = "Azure VM size (type) to be created. Consult the *VM-Series Deployment Guide* as only a few selected sizes are supported."
  default     = "Standard_D3_v2"
  type        = string
}

variable "username" {
  description = "Initial administrative username to use for all systems."
  default     = "panadmin"
  type        = string
}

variable "password" {
  description = "Initial administrative password to use for all systems. Set to null for an auto-generated password."
  default     = "Microsoft=1=1"
  type        = string
}

variable "avzones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "enable_zones" {
  type    = bool
  default = true
}