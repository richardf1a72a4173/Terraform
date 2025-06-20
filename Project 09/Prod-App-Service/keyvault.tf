resource "azurerm_key_vault" "kv" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "kv${local.resource_template}001"
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
  secret_permissions = ["Get", "Set", "List"]

  lifecycle {
    ignore_changes = [object_id]
  }
}

resource "azurerm_key_vault_secret" "sql" {
  name         = "mysql-admin"
  key_vault_id = azurerm_key_vault.kv.id
  value        = azurerm_mysql_flexible_server.mysql.administrator_password
}

resource "azurerm_key_vault_certificate" "ssl" {
  name         = "ag-ssl"
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64("ssl.pfx")
  }
}
