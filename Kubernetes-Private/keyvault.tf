resource "azurerm_key_vault" "kv" {
  name                      = module.naming.key_vault.name
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  sku_name                  = "premium"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
}
