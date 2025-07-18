module "group" {
  source            = "../../../../Modules/Groups"
  group_name        = "PERM-${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_description = "Group providing access to ${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_members     = var.iam_rbac_member_id
  group_owner       = data.azurerm_client_config.current.object_id
  change_number     = var.group_rbac_change_record
}

# resource "azurerm_role_assignment" "rg" {
#   scope                = azurerm_resource_group.rg.id
#   principal_id         = trimprefix(module.group.group_id, "/groups/")
#   role_definition_name = "Reader"
# }

resource "azurerm_role_assignment" "app1" {
  scope                = azurerm_linux_web_app.app.id
  principal_id         = "00000000-0000-0000-0000-000000000000"
  role_definition_name = "Website Contributor"
}

resource "azurerm_role_assignment" "app2" {
  scope                = azurerm_linux_web_app_slot.staging.id
  principal_id         = "00000000-0000-0000-0000-000000000000"
  role_definition_name = "Website Contributor"
}

resource "azurerm_role_assignment" "kv" {
  scope                = azurerm_key_vault.kv.id
  principal_id         = "00000000-0000-0000-0000-000000000000"
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "sa" {
  scope                = azurerm_storage_account.storage.id
  principal_id         = "00000000-0000-0000-0000-000000000000"
  role_definition_name = "Storage File Data Privileged Contributor"
}

resource "azurerm_role_assignment" "kv-uai1" {
  scope                = azurerm_key_vault.kv.id
  principal_id         = azurerm_user_assigned_identity.ag.principal_id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "kv-sai1" {
  scope                = azurerm_key_vault.kv.id
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "kv-currentuser" {
  scope                = azurerm_key_vault.kv.id
  principal_id         = data.azurerm_client_config.current.client_id
  role_definition_name = "Key Vault Secrets Officer"
}

# module "role_assignments" {
#   source  = "Azure/avm-res-authorization-roleassignment/azurerm"
#   version = "0.2.0"

#   enable_telemetry = false

#   groups_by_display_name = {
#     group1 = module.group.group_name
#   }

#   users_by_user_principal_name = {
#     michiel = "c-t0.michiel.winter@example.tld"
#     dimitri = "c-t0.dimitri.vanlommel@example.tld"
#   }

#   user_assigned_managed_identities_by_principal_id = {
#     uai1 = azurerm_user_assigned_identity.ag.principal_id
#   }

#   system_assigned_managed_identities_by_principal_id = {
#     sai1 = azurerm_linux_web_app.app.identity[0].principal_id
#   }

#   role_definitions = {
#     role1 = {
#       name = var.iam_rbac_role
#     }
#     kvso = {
#       name = "Key Vault Secrets Officer"
#     }
#     wc = {
#       name = "Website Contributor"
#     }
#     sfdpc = {
#       name = "Storage File Data Privileged Contributor"
#     }
#   }

#   role_assignments_for_resource_groups = {
#     rg1 = {
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition = "role1"
#           groups          = ["group1"]
#         }
#       }
#     }
#   }

#   role_assignments_for_resources = {
#     kv1 = {
#       resource_name       = azurerm_key_vault.kv.name
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition                    = "kvso"
#           user_assigned_managed_identities   = ["uai1"]
#           system_assigned_managed_identities = ["sai1"]
#           users                              = ["michiel", "dimitri"]
#         }
#       }
#     }
#     app1 = {
#       resource_name       = azurerm_linux_web_app.app.name
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition = "wc"
#           users           = ["michiel", "dimitri"]
#         }
#       }
#     }
#     app2 = {
#       resource_name       = azurerm_linux_web_app_slot.staging.name
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition = "wc"
#           users           = ["michiel", "dimitri"]
#         }
#       }
#     }
#     sa = {
#       resource_name       = azurerm_storage_account.storage.name
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition = "sfdpc"
#           users           = ["michiel", "dimitri"]
#         }
#       }
#     }
#   }

#   depends_on = [module.group]
# }
