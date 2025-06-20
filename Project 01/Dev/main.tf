terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-cloudeng-int-p-001"
    storage_account_name = "saazureengtfstate001"
    container_name       = "tfstate"
    key                  = "bertd001.tfstate"
    use_azuread_auth     = true
    subscription_id      = "00000000-0000-0000-0000-000000000000"
  }

  required_version = ">= 1.7.0"
}

provider "azurerm" {
  subscription_id = local.sub_id
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

#VWAN Hub Provider
provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

data "azurerm_virtual_hub" "us" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-us-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "azurerm_resource_group" "rg" {
  location = local.rg_location
  name     = local.rg_name
  tags     = local.tags
}

resource "azurerm_role_assignment" "rg" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = local.cont_prin_id
}

resource "azurerm_key_vault" "kv" {
  name                        = local.kv_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  enable_rbac_authorization   = true
}

resource "azurerm_key_vault_certificate" "kv" {
  name         = local.kv_cert_name
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64("cert.pfx")
    password = "<pass>"
  }
}

resource "azurerm_role_assignment" "kv" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = azurerm_user_assigned_identity.rg.principal_id
}

#resource "azurerm_role_assignment" "spn" {
#  scope                = azurerm_key_vault.kv.id
#  role_definition_name = "Key Vault Certificates Officer"
#  principal_id         = ""
#}

resource "azurerm_role_assignment" "rf" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_mssql_server" "sql" {
  connection_policy                    = "Default"
  location                             = azurerm_resource_group.rg.location
  minimum_tls_version                  = "1.2"
  name                                 = local.mssql_name
  outbound_network_restriction_enabled = false
  primary_user_assigned_identity_id    = null
  public_network_access_enabled        = false
  resource_group_name                  = azurerm_resource_group.rg.name
  version                              = "12.0"

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = local.sql_db_admin
    object_id                   = local.sql_db_admin_objid
    tenant_id                   = local.sql_db_admin_tenant_id
  }
}

resource "azurerm_mssql_database" "sql" {
  count                               = 2
  auto_pause_delay_in_minutes         = 60
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                         = "Default"
  geo_backup_enabled                  = true
  name                                = element(local.mssql_dbname, count.index)
  read_replica_count                  = 0
  read_scale                          = false
  server_id                           = azurerm_mssql_server.sql.id
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
  zone_redundant                      = false
}

resource "azurerm_service_plan" "rg" {
  count                      = 2
  app_service_environment_id = null
  location                   = azurerm_resource_group.rg.location
  name                       = element(local.app_serplan_name, count.index)
  resource_group_name        = azurerm_resource_group.rg.name
  os_type                    = "Windows"
  sku_name                   = "S1"
}

resource "azurerm_windows_function_app" "fa" {
  count                = 2
  name                 = element(local.function_app_name, count.index)
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  service_plan_id      = azurerm_service_plan.rg[count.index].id
  storage_account_name = azurerm_storage_account.sa[count.index].name

  site_config {

  }
}

resource "azurerm_storage_account" "sa" {
  count                    = 3
  name                     = "${local.sa_name}00${count.index}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Premium"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
}

resource "azurerm_windows_web_app" "app" {
  count               = 2
  name                = element(local.app_service_name, count.index)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = local.serplan_by_name["asp-${local.suffix}-001"].id

  site_config {

  }
}
