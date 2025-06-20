# Target creation with user account, not SPN

module "group" {
  source            = "../../../Modules/Groups"
  group_name        = "PERM-${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_description = "Group providing access to ${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_members     = var.iam_rbac_member_id
  group_owner       = var.iam_rbac_group_owner
  change_number     = var.group_rbac_change_record
}

module "role_assignments" {
  source  = "Azure/avm-res-authorization-roleassignment/azurerm"
  version = "0.1.0"

  enable_telemetry = false

  groups_by_display_name = {
    group1 = module.group.group_name
  }

  users_by_user_principal_name = {
    andy    = "andy@example.tld",
    dominic = "dominic@example.tld",
    craig   = "craig@example.tld"
  }

  user_assigned_managed_identities_by_principal_id = {
    uai1 = azurerm_user_assigned_identity.ag.principal_id
  }

  role_definitions = {
    role1 = {
      name = var.iam_rbac_role
    }
    keyvault = {
      name = "Key Vault Secrets Officer"
    }
    funcapp = {
      name = "Website Contributor"
    }
    storage = {
      name = "Storage Blob Data Contributor"
    }
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
    kv1 = {
      resource_name       = azurerm_key_vault.kv.name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition                  = "keyvault"
          user_assigned_managed_identities = ["uai1"]
          users                            = ["andy", "dominic", "craig"]
        }
      }
    }
    app1 = {
      resource_name       = azurerm_windows_web_app.app[0].name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "funcapp"
          users           = ["andy", "dominic", "craig"]
        }
      }
    }
    app2 = {
      resource_name       = azurerm_windows_web_app.app[1].name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "funcapp"
          users           = ["andy", "dominic", "craig"]
        }
      }
    }
    func1 = {
      resource_name       = azurerm_windows_function_app.fa[0].name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "funcapp"
          users           = ["andy", "dominic", "craig"]
        }
      }
    }
    func2 = {
      resource_name       = azurerm_windows_function_app.fa[1].name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "funcapp"
          users           = ["andy", "dominic", "craig"]
        }
      }
    }
    sa1 = {
      resource_name       = azurerm_storage_account.storage[0].name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "storage"
          users           = ["andy", "dominic", "craig"]
        }
      }
    }
    sa2 = {
      resource_name       = azurerm_storage_account.storage[1].name
      resource_group_name = azurerm_resource_group.rg.name
      role_assignments = {
        role_assignment_1 = {
          role_definition = "storage"
          users           = ["andy", "dominic", "craig"]
        }
      }
    }
  }
}
