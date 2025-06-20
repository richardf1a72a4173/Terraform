resource "azurerm_storage_account" "storage" {
  name                             = "sa${local.safe_basename}001"
  location                         = azurerm_resource_group.rg.location
  resource_group_name              = azurerm_resource_group.rg.name
  account_tier                     = "Premium"
  account_replication_type         = "LRS"
  account_kind                     = "StorageV2"
  cross_tenant_replication_enabled = false
  public_network_access_enabled    = true

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_account_network_rules" "firewall" {
  storage_account_id = azurerm_storage_account.storage.id
  default_action     = "Deny"
  bypass             = ["AzureServices"]
  ip_rules           = [data.http.myip.response_body]
}
