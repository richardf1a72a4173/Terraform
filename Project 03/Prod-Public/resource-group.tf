resource "azurerm_resource_group" "us" {
  name     = "rg${local.resource_template}001"
  location = local.rg_location
  tags     = local.tags
}
