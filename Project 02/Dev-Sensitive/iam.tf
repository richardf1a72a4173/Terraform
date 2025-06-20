# # Target creation with user account, not SPN

module "group" {
  source            = "../../../Modules/Groups"
  group_name        = local.group_name
  group_description = local.group_description
  group_members     = var.iam_rbac_member_id
  group_owner       = var.iam_rbac_group_owner
  change_number     = var.group_rbac_change_record
}

# module "role_assignments" {
#   source = "Azure/avm-res-authorization-roleassignment/azurerm"

#   enable_telemetry = false

#   groups_by_display_name = {
#     group1 = module.group.group_name
#   }

#   role_definitions = {
#     role1 = {
#       name = var.iam_rbac_role
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

#   #   depends_on = [module.group]
# }
