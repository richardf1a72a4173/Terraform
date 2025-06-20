resource "azurerm_monitor_workspace" "monitor" {
  name                = local.monitor_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = local.law_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku               = "PerGB2018"
  retention_in_days = 30
}
