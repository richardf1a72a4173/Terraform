resource "azurerm_storage_account" "storage" {
  name                             = "sa${local.safe_basename}001"
  location                         = azurerm_resource_group.rg.location
  resource_group_name              = azurerm_resource_group.rg.name
  account_tier                     = "Premium"
  account_replication_type         = "ZRS"
  account_kind                     = "FileStorage"
  cross_tenant_replication_enabled = false
  public_network_access_enabled    = true
  min_tls_version                  = "TLS1_2"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_storage_share" "share" {
  name                 = "share${local.safe_basename}001"
  storage_account_name = azurerm_storage_account.storage.name
  # storage_account_id = azurerm_storage_account.storage.id
  quota = 250
}

# resource "azurerm_storage_account_network_rules" "firewall" {
#   storage_account_id = azurerm_storage_account.storage.id
#   default_action     = "Deny"
#   bypass             = ["AzureServices"]
#   ip_rules           = [data.http.myip.response_body]
# }
