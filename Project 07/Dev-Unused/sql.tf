resource "azurerm_mssql_server" "sql" {
  connection_policy                    = "Default"
  location                             = azurerm_resource_group.rg.location
  minimum_tls_version                  = "1.2"
  name                                 = "sql${local.resource_template}001"
  outbound_network_restriction_enabled = false
  primary_user_assigned_identity_id    = null
  public_network_access_enabled        = false
  resource_group_name                  = azurerm_resource_group.rg.name
  version                              = "12.0"

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = var.sql_admin
    object_id                   = var.sql_admin_object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_mssql_database" "sql" {
  count                               = 2
  auto_pause_delay_in_minutes         = 60
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                         = "Default"
  geo_backup_enabled                  = true
  name                                = "sql-db${local.resource_template}00${count.index + 1}"
  read_replica_count                  = 0
  read_scale                          = false
  server_id                           = azurerm_mssql_server.sql.id
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
  zone_redundant                      = false

  lifecycle {
    ignore_changes = [tags, auto_pause_delay_in_minutes]
  }
}
