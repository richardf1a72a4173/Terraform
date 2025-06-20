resource "azurerm_storage_account" "storage" {
  count                         = length(azurerm_windows_function_app.fa)
  name                          = "sa${local.safe_basename}00${count.index + 1}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  account_tier                  = "Premium"
  account_kind                  = "StorageV2"
  account_replication_type      = "LRS"
  public_network_access_enabled = true

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_account_network_rules" "firewall" {
  count              = length(azurerm_storage_account.storage)
  storage_account_id = azurerm_storage_account.storage[count.index].id
  default_action     = "Deny"
  bypass             = ["AzureServices"]
  ip_rules           = [data.http.myip.response_body]
}
