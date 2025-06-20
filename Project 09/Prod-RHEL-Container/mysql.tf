resource "azurerm_user_assigned_identity" "sql" {
  name                = "uai-mysql${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  lifecycle {
    ignore_changes = [tags]
  }
}

# resource "azurerm_key_vault_key" "sql" {
#   name         = "key-cmk-mysql${local.resource_template}001"
#   key_vault_id = azurerm_key_vault.kv.id

#   key_type = "RSA-HSM"

#   key_size = "2048"

#   key_opts = [
#     "decrypt",
#     "encrypt",
#     "sign",
#     "unwrapKey",
#     "verify",
#     "wrapKey",
#   ]
# }

resource "azurerm_mysql_flexible_server" "mysql" {
  name                = "mysql${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login    = var.mysql_admin
  administrator_password = var.mysql_password
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.sql.id
  sku_name               = "GP_Standard_D2ds_v4"
  private_dns_zone_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.mysql.database.azure.com"

  geo_redundant_backup_enabled = false
  zone                         = null

  # dynamic "high_availability" {
  #   for_each = local.env == "p" ? [1] : []
  #   content {
  #     mode                      = "ZoneRedundant"
  #     standby_availability_zone = "3"
  #   }
  # }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.sql.id]
  }

  # customer_managed_key {
  #   key_vault_key_id                  = azurerm_key_vault_key.sql.id
  #   primary_user_assigned_identity_id = azurerm_user_assigned_identity.sql.id
  # }

  lifecycle {
    ignore_changes        = [tags, zone]
    create_before_destroy = false
  }
}

resource "azurerm_mysql_flexible_database" "database" {
  name                = "mysql-db${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
}
