variable "virtual_hub_name" {
  type        = string
  description = "(Required) Specifies the name of the Virtual WAN. Changing this forces a new resource to be created."
}

variable "virtual_hub_resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Virtual WAN. Changing this forces a new resource to be created."
}

variable "virtual_hub_location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the Virtual Hub should exist. Changing this forces a new resource to be created."
}

variable "virtual_hub_virtual_wan_id" {
  type        = string
  description = "(Optional) The ID of a Virtual WAN within which the Virtual Hub should be created. Changing this forces a new resource to be created."
}

variable "virtual_hub_address_prefix" {
  type        = string
  description = "(Optional) The Address Prefix which should be used for this Virtual Hub. Changing this forces a new resource to be created. The address prefix subnet cannot be smaller than a /24. Azure recommends using a /23"
}

variable "virtual_hub_sku" {
  type        = string
  description = "(Optional) The sku of the Virtual Hub. Possible values are Basic and Standard. Changing this forces a new resource to be created."
  default     = "Standard"
}

# variable "virtual_hub_static_route" {
#   type = bool
#   description = "Enable static routing on Virutal Hub"
#   default = false
# }

# variable "virtual_hub_route_address_prefixes" {
#   type = list(string)
#   description = "(Required) A list of Address Prefixes."
#   default = [ "" ]
# }

# variable "virtual_hub_route_nexnext_hop_ip_address" {
#   type = string
#   description = "(Required) The IP Address that Packets should be forwarded to as the Next Hop."
#   default = ""
# }

variable "virtual_hub_static_route" {
  type = list(object({
    virtual_hub_route_address_prefixes       = list(string)
    virtual_hub_route_nexnext_hop_ip_address = string
  }))
  description = "virtual hub static routes"
  default     = []
}

variable "virtual_hub_tags" {
  type    = map(string)
  default = {}
}

// Secure Hub/Firewall Section
variable "virtual_hub_secured" {
  type        = bool
  description = "(Optional) Boolean flag to enable secured hub. Defaults to true"
  default     = false
}

variable "virtual_hub_fw_name" {
  type        = string
  description = "(Optional) Specifies the name of the Firewall. Changing this forces a new resource to be created."
  default     = null
}

variable "virtual_hub_fw_resource_group_name" {
  type        = string
  description = "(Optional) The name of the resource group in which to create the resource. Changing this forces a new resource to be created."
  default     = null
}

variable "virtual_hub_fw_location" {
  type        = string
  description = "(Optional) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = null
}

variable "virtual_hub_fw_sku_name" {
  type        = string
  description = "(Optional) Sku name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created."
  default     = "AZFW_Hub"
}

variable "virtual_hub_fw_sku_tier" {
  type        = string
  description = "(Optional) Sku tier of the Firewall. Possible values are Premium and Standard. Changing this forces a new resource to be created."
  default     = "Premium"
}

variable "virtual_hub_fw_policy_id" {
  type        = string
  description = "(Optional) The ID of the Firewall Policy applied to this Firewall."
  default     = null
}

variable "virtual_hub_fw_zones" {
  type        = list(string)
  description = "(Optional) Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created."
  default     = null
}

variable "virtual_hub_fw_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "virtual_hub_fw_log_analytics_workspace_id" {
  type        = string
  description = "(Required) ID of the LogAnalytics Workspace"
  default     = "/subscriptions/7a883164-75f4-4413-adb1-2e37388e30ed/resourceGroups/azrweuinfrg0003/providers/Microsoft.OperationalInsights/workspaces/azrweugblla0001"
}
