# resource "azurerm_synapse_workspace" "workspace" {
#   name                                 = local.synapse_workspace_name
#   resource_group_name                  = azurerm_resource_group.rg.name
#   storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.dlfs.id
#   location                             = azurerm_resource_group.rg.location

#   identity {
#     type = "SystemAssigned"
#   }

#   lifecycle {
#     prevent_destroy = true
#     ignore_changes  = [sql_administrator_login, tags]
#   }
# }

# resource "azurerm_synapse_workspace_aad_admin" "workspace" {
#   synapse_workspace_id = azurerm_synapse_workspace.workspace.id
#   login                = var.iam_rbac_member
#   object_id            = var.iam_rbac_member_id
#   tenant_id            = data.azurerm_client_config.current.tenant_id
# }

# resource "azurerm_synapse_workspace_sql_aad_admin" "workspace" {
#   synapse_workspace_id = azurerm_synapse_workspace.workspace.id
#   login                = var.iam_rbac_member
#   object_id            = var.iam_rbac_member_id
#   tenant_id            = data.azurerm_client_config.current.tenant_id
# }

# resource "azurerm_synapse_spark_pool" "syn_spark" {
#   name                 = local.syn_spark_pool_name
#   synapse_workspace_id = azurerm_synapse_workspace.workspace.id
#   node_size_family     = "MemoryOptimized"
#   node_size            = "Small"

#   spark_version = "3.3"

#   auto_scale {
#     max_node_count = 50
#     min_node_count = 3
#   }

#   auto_pause {
#     delay_in_minutes = 15
#   }

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_synapse_firewall_rule" "terraform" {
#   name                 = "AllowTerraform"
#   synapse_workspace_id = azurerm_synapse_workspace.workspace.id
#   start_ip_address     = chomp(data.http.myip.response_body)
#   end_ip_address       = chomp(data.http.myip.response_body)
# }

# resource "azurerm_synapse_role_assignment" "synadmin" {
#   synapse_workspace_id = azurerm_synapse_workspace.workspace.id
#   role_name            = "Synapse Administrator"
#   principal_id         = var.iam_rbac_member_id
#   principal_type       = "User"
#   depends_on           = [azurerm_synapse_firewall_rule.terraform]
# }

# resource "azurerm_synapse_firewall_rule" "jmdev" {
#   name                 = "AllowDev"
#   synapse_workspace_id = azurerm_synapse_workspace.workspace.id
#   start_ip_address     = var.dev_pip
#   end_ip_address       = var.dev_pip

#   lifecycle {
#     ignore_changes = [start_ip_address, end_ip_address]
#   }
# }
