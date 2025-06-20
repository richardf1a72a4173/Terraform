resource "azurerm_storage_account" "storage" {
  name                     = local.sa_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Premium"
  account_replication_type = "ZRS"
  account_kind             = "FileStorage"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_share" "share" {
  name                 = local.share_name
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 250
}
