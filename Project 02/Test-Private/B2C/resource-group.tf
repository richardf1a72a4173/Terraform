resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.rg_location
  tags     = local.tags
}

resource "azurerm_management_lock" "rg" {
  name       = "DeleteLock"
  lock_level = "CanNotDelete"
  scope      = azurerm_resource_group.rg.id
}
