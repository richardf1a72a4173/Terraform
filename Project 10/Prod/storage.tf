resource "azurerm_storage_account" "storage" {
  name                             = "sa${local.safe_basename}001"
  location                         = azurerm_resource_group.us.location
  resource_group_name              = azurerm_resource_group.us.name
  # account_tier                     = "Premium"
  account_tier                     = "Standard"
  account_replication_type         = "ZRS"
  cross_tenant_replication_enabled = false

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_container" "container" {
  storage_account_name = azurerm_storage_account.storage.name
  name                  = "ftresults"
  # storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.storage
    ]
}