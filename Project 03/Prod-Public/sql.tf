# DB Server

resource "azurerm_mssql_server" "us" {
  connection_policy                    = "Default"
  location                             = azurerm_resource_group.us.location
  minimum_tls_version                  = "1.2"
  name                                 = module.naming.mssql_server.name
  outbound_network_restriction_enabled = false
  primary_user_assigned_identity_id    = null
  public_network_access_enabled        = true
  resource_group_name                  = azurerm_resource_group.us.name
  version                              = "12.0"

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = var.sql_login_username
    object_id                   = var.sql_login_object_id
    tenant_id                   = data.azuread_client_config.current.tenant_id
  }

  lifecycle {
    ignore_changes = [tags, azuread_administrator]
    # prevent_destroy = true
  }
}

resource "azurerm_mssql_database" "us" {
  count                               = 2
  auto_pause_delay_in_minutes         = 0
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                         = "Default"
  geo_backup_enabled                  = true
  name                                = "${module.naming.mssql_database.name}-00${count.index + 1}"
  read_replica_count                  = 0
  read_scale                          = false
  server_id                           = azurerm_mssql_server.us.id
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
  zone_redundant                      = false
  sku_name                            = "S3"
  max_size_gb                         = 60

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = "AzureServices"
  server_id        = azurerm_mssql_server.us.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
