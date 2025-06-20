resource "azurerm_resource_group" "backup" {
  name     = "rg-backup${local.resource_template}001"
  location = azurerm_resource_group.rg.location
  tags     = local.tags
}

resource "azurerm_management_lock" "backup" {
  name       = "DeleteLock"
  lock_level = "CanNotDelete"
  scope      = azurerm_resource_group.backup.id
}

resource "azurerm_recovery_services_vault" "vault" {
  name                         = "vault${local.resource_template}001"
  location                     = azurerm_resource_group.backup.location
  resource_group_name          = azurerm_resource_group.backup.name
  sku                          = "Standard"
  immutability                 = "Locked"
  storage_mode_type            = "GeoRedundant"
  cross_region_restore_enabled = true

  timeouts {
    create = "30m"
  }
}

resource "azurerm_backup_policy_file_share" "files" {
  name                = "files-backup${local.resource_template}001"
  resource_group_name = azurerm_resource_group.backup.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "01:00"
  }

  retention_daily {
    count = 10
  }

  dynamic "retention_weekly" {
    for_each = local.env == "p" ? [1] : []
    content {
      count    = 7
      weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
    }
  }

  dynamic "retention_monthly" {
    for_each = local.env == "p" ? [1] : []
    content {
      count    = 7
      weekdays = ["Sunday", "Wednesday"]
      weeks    = ["First", "Last"]
    }
  }

  dynamic "retention_yearly" {
    for_each = local.env == "p" ? [1] : []
    content {
      count    = 7
      weekdays = ["Sunday"]
      weeks    = ["Last"]
      months   = ["January"]
    }
  }
}

resource "azurerm_backup_container_storage_account" "storage" {
  resource_group_name = azurerm_resource_group.backup.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  storage_account_id  = azurerm_storage_account.storage.id

  depends_on = [azurerm_recovery_services_vault.vault, azurerm_storage_account.storage]
}

resource "azurerm_backup_protected_file_share" "share" {
  resource_group_name       = azurerm_resource_group.backup.name
  recovery_vault_name       = azurerm_recovery_services_vault.vault.name
  source_storage_account_id = azurerm_storage_account.storage.id
  source_file_share_name    = azurerm_storage_share.share.name
  backup_policy_id          = azurerm_backup_policy_file_share.files.id

  depends_on = [azurerm_recovery_services_vault.vault, azurerm_storage_share.share]
}
