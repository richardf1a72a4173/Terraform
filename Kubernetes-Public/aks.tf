module "avm-res-containerservice-managedcluster" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.1.9"

  name                     = module.naming.kubernetes_cluster.name_unique
  resource_group_name      = azurerm_resource_group.this.name
  node_resource_group_name = "${azurerm_resource_group.this.name}-node"
  location                 = azurerm_resource_group.this.location

  # azure_active_directory_role_based_access_control = {
  #   azure_rbac_enabled = true
  #   tenant_id          = data.azurerm_client_config.current.tenant_id
  # }

  local_account_disabled = false

  default_node_pool = {
    name       = "default"
    vm_size    = "Standard_DS2_v2"
    node_count = 3
    upgrade_settings = {
      max_surge = "10%"
    }
  }

  maintenance_window_auto_upgrade = {
    frequency   = "Weekly"
    interval    = "1"
    day_of_week = "Sunday"
    duration    = 4
    utc_offset  = "+00:00"
    start_time  = "00:00"
    start_date  = "2024-10-15T00:00:00Z"
  }

  managed_identities = {
    system_assigned = true
  }
}
