resource "azurerm_resource_group" "us" {
  location = local.rg_location
  name     = local.rg_name
  tags     = local.tags

  lifecycle {
    ignore_changes = [tags]
  }
}