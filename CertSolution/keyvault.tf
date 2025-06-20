resource "azurerm_key_vault" "kv" {
  name                = local.kvname
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  lifecycle {
    ignore_changes = [tags]
  }
}

# resource "azurerm_key_vault_access_policy" "policy" {
#   object_id    = data.azurerm_client_config.current.object_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   key_vault_id = azurerm_key_vault.kv.id
# }
