removed {
  from = azurerm_user_assigned_identity.cdnkv
  lifecycle {
    destroy = false
  }
}

removed {
  from = module.role_assignments
  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_aadb2c_directory.b2c
  lifecycle {
    destroy = false
  }
}

removed {
  from = random_password.password
  lifecycle {
    destroy = false
  }
}

removed {
  from = azuread_user.users
  lifecycle {
    destroy = false
  }
}

removed {
  from = azuread_directory_role.ga
  lifecycle {
    destroy = false
  }
}

removed {
  from = azuread_directory_role_assignment.ga
  lifecycle {
    destroy = false
  }
}
