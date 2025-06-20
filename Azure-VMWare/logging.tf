resource "azurerm_monitor_workspace" "monitor" {
  name                = "mon-${trim(local.resource_template, "-")}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_log_analytics_workspace" "this_workspace" {
  name                = module.naming.log_analytics_workspace.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku               = "PerGB2018"
  retention_in_days = 30
}
