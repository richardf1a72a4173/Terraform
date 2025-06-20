resource "azurerm_storage_account" "storage" {
  count = 2

  name                     = "sthrsysicimsp00${count.index + 1}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.snets[0].id, azurerm_subnet.snets[1].id, azurerm_subnet.snets[2].id]
    bypass                     = ["AzureServices"]
    ip_rules                   = [data.http.myip.response_body]
  }

  lifecycle {
    ignore_changes = [tags, network_rules]
  }
}
