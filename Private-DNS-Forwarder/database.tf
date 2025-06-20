resource "azurerm_mysql_flexible_server" "db" {
  name                = "db${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  administrator_login    = "<user>"
  administrator_password = "<pass>"

  backup_retention_days = 2
  delegated_subnet_id   = azurerm_subnet.db.id
  private_dns_zone_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.mysql.database.azure.com"
  sku_name              = "GP_Standard_D2ds_v4"

  lifecycle {
    ignore_changes = [tags, zone]
    # prevent_destroy = true
  }
}

resource "azurerm_mysql_flexible_server_configuration" "secure_connection" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db.name
  value               = "off"
}

resource "azurerm_mysql_flexible_server_configuration" "character_set_server" {
  name                = "character_set_server"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db.name
  value               = "utf8"
}

resource "azurerm_mysql_flexible_server_configuration" "collation_server" {
  name                = "collation_server"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db.name
  value               = "utf8_unicode_ci"
}
