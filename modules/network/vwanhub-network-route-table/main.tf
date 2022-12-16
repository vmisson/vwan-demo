resource "azurerm_virtual_hub_route_table" "main" {
  name           = var.route_table_name
  virtual_hub_id = var.vwan_hub_id
  labels         = var.labels
}