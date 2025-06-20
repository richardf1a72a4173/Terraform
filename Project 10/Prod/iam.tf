module "group" {
  source            = "../../../Modules/Groups"
  group_name        = local.group_name
  group_description = local.group_description
  group_members     = var.iam_rbac_member_id
  group_owner       = var.iam_rbac_group_owner
  change_number     = var.group_rbac_change_record
}

module "avm-res-authorization-roleassignment" {
  source  = "Azure/avm-res-authorization-roleassignment/azurerm"
  version = "0.0.1"

  enable_telemetry = false

  groups_by_object_id = {
    group1 = module.group.group_id
  }

  users_by_object_id = {
    user1 = "00000000-0000-0000-0000-000000000000" # mgdev.dallas@example.tld
  }

  role_definitions = {
    role1 = var.iam_rbac_role
  }

  role_assignments_for_resource_groups = {
    rg1 = {
      resource_group_name = azurerm_resource_group.us.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "role1"
          groups          = ["group1"]
        }
      }
    }
  }

  depends_on = [module.group, azurerm_resource_group.us]
}
