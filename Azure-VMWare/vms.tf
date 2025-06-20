module "private_cloud" {
  source  = "Azure/avm-res-avs-privatecloud/azurerm"
  version = "0.8.2"

  enable_telemetry           = false
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  resource_group_resource_id = azurerm_resource_group.this.id
  name                       = "avs-sddc-${substr(module.naming.unique-seed, 0, 4)}"
  sku_name                   = "av20"
  avs_network_cidr           = var.vnet_subnet
  internet_enabled           = false
  management_cluster_size    = 3

  diagnostic_settings = {
    avs_diags = {
      name                  = module.naming.monitor_diagnostic_setting.name_unique
      workspace_resource_id = azurerm_log_analytics_workspace.this_workspace.id
      metric_categories     = ["AllMetrics"]
      log_groups            = ["allLogs"]
    }
  }

  depends_on = [azurerm_resource_group.this]
}
