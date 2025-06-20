module "group" {
  source            = "../../../Modules/Groups"
  group_name        = "PERM-${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_description = "Group providing access to ${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_members     = var.iam_rbac_member_id
  group_owner       = var.iam_rbac_group_owner
  change_number     = var.group_rbac_change_record
}

# module "role_assignments" {
#   source           = "Azure/avm-res-authorization-roleassignment/azurerm"
#   version          = "0.1.0"
#   enable_telemetry = false

#   users_by_user_principal_name = {
#     james = "c-t0.james.morel@example.tld"
#     garry = "c-t0.garry.grierson@example.tld"
#   }

#   groups_by_display_name = {
#     group1 = module.group.group_name
#   }

#   user_assigned_managed_identities_by_principal_id = {
#     uai1 = azurerm_user_assigned_identity.ag.principal_id
#   }

#   system_assigned_managed_identities_by_principal_id = {
#     smi1 = azurerm_logic_app_standard.la[0].identity[0].principal_id
#     smi2 = azurerm_logic_app_standard.la[1].identity[0].principal_id
#   }

#   role_definitions = {
#     role1 = {
#       name = var.iam_rbac_role
#     }
#     kvso = {
#       name = "Key Vault Secrets Officer"
#     }
#     lac = {
#       name = "Contributor"
#     }
#     sbdo = {
#       name = "Azure Service Bus Data Owner"
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
#           role_definition                   = "kvso"
#           user_assigned_managed_identities  = ["uai1"]
#           system_assigned_managed_identites = ["smi1", "smi2"]
#           users                             = ["james", "garry"]
#         }
#       }
#     }
#     la1 = {
#       resource_name       = azurerm_logic_app_standard.la[0].name
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition = "lac"
#           users           = ["james", "garry"]
#         }
#       }
#     }
#     la2 = {
#       resource_name       = azurerm_logic_app_standard.la[1].name
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition = "lac"
#           users           = ["james", "garry"]
#         }
#       }
#     }
#     sb1 = {
#       resource_name       = azurerm_servicebus_namespace.namespace.name
#       resource_group_name = azurerm_resource_group.rg.name
#       role_assignments = {
#         role_assignment_1 = {
#           role_definition                   = "sbdo"
#           users                             = ["james", "garry"]
#           system_assigned_managed_identites = ["smi1", "smi2"]
#         }
#       }
#     }
#   }

#   depends_on = [module.group]
# }

removed {
  from = module.role_assignments
  lifecycle {
    destroy = false
  }
}
