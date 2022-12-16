locals {
  resource_group_tags = merge(
    tomap({
      ManagedBy = "terraform/resourcegroup"
    }),
    var.resource_group_tags,
  )
}

resource "azurerm_resource_group" "resource-group" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = local.resource_group_tags
}