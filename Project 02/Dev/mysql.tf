resource "azurerm_mysql_flexible_server" "mysql" {
  name                = local.mysql_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login    = var.mysql_admin
  administrator_password = var.mysql_password
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.sql.id
  sku_name               = "GP_Standard_D2ds_v4"
  private_dns_zone_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.mysql.database.azure.com"

  geo_redundant_backup_enabled = local.env == "p" ? true : false

  lifecycle {
    ignore_changes        = [tags, zone]
    create_before_destroy = false
  }
}

resource "azurerm_mysql_flexible_database" "database" {
  name                = local.db_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
