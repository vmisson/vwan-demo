locals {
  virtual_hub_vpn_gateway_tags = merge(
    tomap({
      ManagedBy = "terraform/virtual-wan"
    }),
    var.virtual_hub_vpn_gateway_tags
  )
}

resource "azurerm_vpn_gateway" "vpn_gateway" {
  name                = var.virtual_hub_vpn_gateway_name
  resource_group_name = var.virtual_hub_vpn_gateway_resource_group
  location            = var.virtual_hub_vpn_gateway_location
  virtual_hub_id      = var.virtual_hub_vpn_gateway_virtual_hub_id
  scale_unit          = var.virtual_hub_vpn_gateway_scale_unit
  tags                = local.virtual_hub_vpn_gateway_tags
}
