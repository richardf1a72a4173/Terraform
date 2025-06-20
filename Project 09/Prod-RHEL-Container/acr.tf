resource "azurerm_container_registry" "myacr" {
  name                          = "acr${local.safe_basename}001"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = "Premium"
  admin_enabled                 = true
  public_network_access_enabled = false
}
