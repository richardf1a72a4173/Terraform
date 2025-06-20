resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.rg_location
  tags     = local.tags
}