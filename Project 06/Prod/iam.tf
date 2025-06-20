module "group" {
  source            = "../../Modules/Groups"
  group_name        = "PERM${local.resource_template}001 ${var.iam_rbac_role}"
  group_description = "Group providing access to ${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_members     = [var.iam_rbac_member_id]
  group_owner       = var.iam_rbac_group_owner
  change_number     = var.group_rbac_change_record
}

module "role_assignments" {
  source = "Azure/avm-res-authorization-roleassignment/azurerm"

  enable_telemetry = false

  groups_by_display_name = {
    group1 = data.azuread_group.rbac_group.display_name
  }

  role_definitions = {
    role1 = {
      name = var.iam_rbac_role
    }
    role2 = {
      name = "Storage Blob Data Contributor"
    }
    role3 = {
      name = "Owner"
    }
  }

  users_by_user_principal_name = {
    user1 = var.iam_rbac_member
  }

  role_assignments_for_resource_groups = {
    rg1 = {
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "role1"
          groups          = ["group1"]
        }
      }
    }
  }

  role_assignments_for_resources = {
    sa1 = {
      resource_name       = azurerm_storage_account.dl_st.name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "role2"
          users           = ["user1"]
        }
        role_assignment_2 = {
          role_definition = "role3"
          users           = ["user1"]
        }
      }
    }
  }

  depends_on = [module.group]
}
