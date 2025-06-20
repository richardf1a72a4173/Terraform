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
    key                  = "aqccd001.tfstate"
    use_azuread_auth     = true
    subscription_id      = "00000000-0000-0000-0000-000000000000"
  }

  required_version = ">= 1.7.0"
}

provider "azurerm" {
  subscription_id = local.sub_id
  features {}
}

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

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "us" {
  location = local.rg_location
  name     = local.rg_name
  tags     = local.tags
}

# Assign RG Permissions
resource "azurerm_role_assignment" "us" {
  scope                = azurerm_resource_group.us.id
  role_definition_name = "Contributor"
  principal_id         = local.cont_prin_id
}

# DB Server

resource "azurerm_mssql_server" "us" {
  connection_policy                    = "Default"
  location                             = azurerm_resource_group.us.location
  minimum_tls_version                  = "1.2"
  name                                 = local.mssql_name
  outbound_network_restriction_enabled = false
  primary_user_assigned_identity_id    = null
  public_network_access_enabled        = true
  resource_group_name                  = azurerm_resource_group.us.name
  version                              = "12.0"
  azuread_administrator {
    azuread_authentication_only = true
    login_username              = "mgdev.dallas@example.tld" #Cloud Accounts?
    object_id                   = "00000000-0000-0000-0000-000000000000"
    tenant_id                   = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_mssql_database" "us" {
  auto_pause_delay_in_minutes         = 0
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                         = "Default"
  geo_backup_enabled                  = true
  name                                = local.sqldb_name
  read_replica_count                  = 0
  read_scale                          = false
  server_id                           = azurerm_mssql_server.us.id
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
  zone_redundant                      = false
}

# Storage Account

resource "azurerm_storage_account" "us" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.us.name
  location                 = azurerm_resource_group.us.location
  account_tier             = "Premium"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
}

# App Service Plan

resource "azurerm_service_plan" "us" {
  app_service_environment_id = null
  location                   = azurerm_resource_group.us.location
  name                       = local.app_serplan_name
  resource_group_name        = azurerm_resource_group.us.name
  os_type                    = "Windows"
  sku_name                   = "S1"
}

# App Service

resource "azurerm_windows_web_app" "us" {
  lifecycle {
    ignore_changes = [site_config, app_settings, auth_settings_v2, sticky_settings]
  }
  name                = local.app_name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_service_plan.us.location
  service_plan_id     = azurerm_service_plan.us.id

  site_config {}
}
