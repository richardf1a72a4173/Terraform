resource "azurerm_key_vault" "kv" {
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  name                            = "kv${local.resource_template}001"
  sku_name                        = "premium"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization       = true
  enabled_for_template_deployment = true
  public_network_access_enabled   = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [data.http.myip.response_body]
    virtual_network_subnet_ids = [
      azurerm_subnet.app.id,
      azurerm_subnet.app-gw.id,
      azurerm_subnet.pe.id,
      azurerm_subnet.sql.id
    ]
  }

  lifecycle {
    ignore_changes = [tags, soft_delete_retention_days]
  }
}

resource "azurerm_key_vault_secret" "sql" {
  name            = "mysql-admin"
  key_vault_id    = azurerm_key_vault.kv.id
  value           = azurerm_mysql_flexible_server.mysql.administrator_password
  content_type    = "text/plain"
  expiration_date = timeadd(time_static.time.rfc3339, "4383h")
}
