resource "azurerm_storage_account" "storage" {
  count = 2

  name                     = "sa${local.safe_basename}00${count.index + 1}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  lifecycle {
    ignore_changes = [tags]
  }
}
