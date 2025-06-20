resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name
  location = local.rg_location
  tags     = local.tags
}
