resource "azurerm_storage_account" "ingest" {
  name                              = "st${local.safe_basename}001"
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  account_tier                      = "Premium"
  account_replication_type          = "GZRS"
  account_kind                      = "FileStorage"
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = true

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules = [
      data.http.myip.response_body
    ]
  }
}

resource "azurerm_storage_share" "ingest" {
  name               = module.naming.storage_share.name
  quota              = "1000"
  storage_account_id = azurerm_storage_account.ingest.id
}

resource "azurerm_storage_account" "archive" {
  name                              = "st${local.safe_basename}002"
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  account_tier                      = "Premium"
  account_replication_type          = "GZRS"
  account_kind                      = "BlobStorage"
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = true

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules = [
      data.http.myip.response_body
    ]
  }
}

resource "azurerm_storage_container" "archive" {
  name               = module.naming.storage_blob.name
  storage_account_id = azurerm_storage_account.archive.id
}

resource "azurerm_storage_management_policy" "archive" {
  storage_account_id = azurerm_storage_account.archive.id
}
