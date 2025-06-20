# Storage Account

resource "azurerm_storage_account" "us" {
  name                          = local.sa_name
  resource_group_name           = azurerm_resource_group.us.name
  location                      = azurerm_resource_group.us.location
  account_tier                  = "Premium"
  account_kind                  = "BlockBlobStorage"
  account_replication_type      = "LRS"
  public_network_access_enabled = true

  lifecycle {
    ignore_changes = [tags, cross_tenant_replication_enabled, public_network_access_enabled]
    # prevent_destroy = true
  }
}

resource "azurerm_storage_container" "container" {

  count                 = 2
  name                  = local.sa_container_name[count.index]
  storage_account_name  = azurerm_storage_account.us.name
  container_access_type = "private"

  lifecycle {
    # prevent_destroy = true
  }
}