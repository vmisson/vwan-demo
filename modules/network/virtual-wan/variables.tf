variable "virtual_wan_name" {
  type        = string
  description = "(Required) Specifies the name of the Virtual WAN. Changing this forces a new resource to be created."
}

variable "virtual_wan_resource_group" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Virtual WAN. Changing this forces a new resource to be created."
}

variable "virtual_wan_location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "virtual_wan_disable_vpn_encryption" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether VPN encryption is disabled. Defaults to false."
  default     = false
}

variable "virtual_wan_allow_branch_to_branch_traffic" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether branch to branch traffic is allowed. Defaults to true."
  default     = true
}

variable "virtual_wan_office365_local_breakout_category" {
  type        = string
  description = "(Optional) Specifies the Office365 local breakout category. Possible values include: Optimize, OptimizeAndAllow, All, None. Defaults to None."
  default     = "None"
}

variable "virtual_wan_type" {
  type        = string
  description = "(Optional) Specifies the Virtual WAN type. Possible Values include: Basic and Standard. Defaults to Standard."
  default     = "Standard"
}

variable "virtual_wan_tags" {
  type    = map(string)
  default = {}
}