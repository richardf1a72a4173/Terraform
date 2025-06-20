resource "azurerm_storage_account" "dl_st" {
  name                     = local.storage_account_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dlfs" {
  name               = local.storage_dlfs_name
  storage_account_id = azurerm_storage_account.dl_st.id
}