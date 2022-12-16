module "vwan_resource_group" {
  source = "./modules/resourcegroup"

  resource_group_name     = var.resource_group_name
  resource_group_location = var.vwan_location
}

module "vwan" {
  source = "./modules/network/virtual-wan"

  virtual_wan_name           = "demo-vwan-0001"
  virtual_wan_resource_group = module.vwan_resource_group.resource-group-name
  virtual_wan_location       = var.vwan_location
}
