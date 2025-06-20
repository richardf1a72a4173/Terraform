resource "azurerm_storage_account" "dl_st" {
  name                     = "sa${local.safe_basename}001"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

  lifecycle {
    ignore_changes  = [tags]
    prevent_destroy = true
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dlfs" {
  name               = "sdlfs${local.resource_template}001"
  storage_account_id = azurerm_storage_account.dl_st.id
}
