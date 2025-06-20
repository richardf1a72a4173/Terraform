resource "azurerm_key_vault" "kv" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = local.kv_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id       = azurerm_key_vault.kv.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get"]

  lifecycle {
    ignore_changes = [object_id]
  }
}
