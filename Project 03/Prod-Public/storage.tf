# Storage Account

resource "azurerm_storage_account" "us" {
  name                            = module.naming.storage_account.name_unique
  resource_group_name             = azurerm_resource_group.us.name
  location                        = azurerm_resource_group.us.location
  account_tier                    = "Premium"
  account_kind                    = "BlockBlobStorage"
  account_replication_type        = "LRS"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  lifecycle {
    ignore_changes = [tags, cross_tenant_replication_enabled]
    # prevent_destroy = true
  }
}

resource "azurerm_storage_container" "container" {
  count                 = 2
  name                  = "${module.naming.storage_container.name_unique}-00${count.index + 1}"
  storage_account_name  = azurerm_storage_account.us.name
  container_access_type = "private"

  lifecycle {
    # prevent_destroy = true
  }

  depends_on = [azurerm_role_assignment.storage-me]
}

resource "azurerm_storage_account_network_rules" "firewall" {
  storage_account_id = azurerm_storage_account.us.id
  default_action     = "Deny"
  bypass             = ["AzureServices"]
  ip_rules = [
    var.dev_ip,
    data.http.myip.response_body
  ]
}
