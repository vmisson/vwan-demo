locals {
  virtual_wan_tags = merge(
    tomap({
      ManagedBy = "terraform/virtual-wan"
    }),
    var.virtual_wan_tags,
  )
}

resource "azurerm_virtual_wan" "virtual-wan" {
  name                              = var.virtual_wan_name
  resource_group_name               = var.virtual_wan_resource_group
  location                          = var.virtual_wan_location
  disable_vpn_encryption            = var.virtual_wan_disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.virtual_wan_allow_branch_to_branch_traffic
  office365_local_breakout_category = var.virtual_wan_office365_local_breakout_category
  type                              = var.virtual_wan_type
  tags                              = local.virtual_wan_tags
}
