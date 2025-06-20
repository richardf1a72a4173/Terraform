# DB Server

resource "azurerm_mssql_server" "us" {
  connection_policy                    = "Default"
  location                             = azurerm_resource_group.us.location
  minimum_tls_version                  = "1.2"
  name                                 = local.mssql_name
  outbound_network_restriction_enabled = false
  primary_user_assigned_identity_id    = null
  public_network_access_enabled        = true
  resource_group_name                  = azurerm_resource_group.us.name
  version                              = "12.0"
  azuread_administrator {
    azuread_authentication_only = true
    login_username              = var.dblogin_username
    object_id                   = var.dbobject_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_mssql_database" "us" {
  auto_pause_delay_in_minutes         = 0
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                         = "Default"
  geo_backup_enabled                  = true
  name                                = local.sqldb_name
  read_replica_count                  = 0
  read_scale                          = false
  server_id                           = azurerm_mssql_server.us.id
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
  zone_redundant                      = false
  sku_name                            = "GP_Gen5_4"
  max_size_gb                         = 80

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [azurerm_user_assigned_identity.uai]
}

resource "azurerm_mssql_firewall_rule" "FirewallRule1" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.us.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_user_assigned_identity" "uai" {
  name                = "uai-mysql${local.resource_template}001"
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
}
