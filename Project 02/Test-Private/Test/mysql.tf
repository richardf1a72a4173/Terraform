resource "azurerm_user_assigned_identity" "sql" {
  name                = "${module.naming.mysql_server.name}-uai"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                = module.naming.mysql_server.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login    = var.mysql_admin
  administrator_password = var.mysql_password
  # backup_retention_days  = 7
  delegated_subnet_id = azurerm_subnet.sql.id
  sku_name            = "GP_Standard_D2ds_v4"
  private_dns_zone_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.mysql.database.azure.com"

  version = "8.0.21"

  # geo_redundant_backup_enabled = local.env == "p" ? true : false
  # zone                         = local.env == "p" ? "2" : null

  # dynamic "high_availability" {
  #   for_each = local.env == "p" ? [1] : []
  #   content {
  #     mode                      = "SameZone"
  #     standby_availability_zone = "2"
  #   }
  # }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.sql.id]
  }

  lifecycle {
    ignore_changes        = [tags, zone]
    create_before_destroy = false
  }
}

resource "azurerm_mysql_flexible_database" "database" {
  name                = module.naming.mysql_database.name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}
