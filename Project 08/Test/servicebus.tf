resource "azurerm_servicebus_namespace" "namespace" {
  name                          = module.naming.servicebus_namespace.name
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = "Premium"
  capacity                      = 1
  premium_messaging_partitions  = 1
  public_network_access_enabled = true

  lifecycle {
    ignore_changes = [tags]
  }
}
