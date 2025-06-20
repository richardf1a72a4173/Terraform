# Configure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000" #Production - Online
  features {}
}

locals {
  rg_location = "eastus2"
  rg_name     = "rg-project04-p-001"

  df_name       = "df-project04-p-001"
  mssql_name    = "azus-sql-project04-p-001"
  mssql_dbname  = "sql-project04-p-001"
  logic_appname = "la-project04-p-001"
  sa_name       = "saproject04p001"
  asp_name      = "asp-project04-p-001"

  tags = {
    "Active Directory" = "n/a"
    "Application Name" = "project04 - Prod"
    Confidentiality    = "n/a"
    "Cost Centre"      = ""
    Environment        = "Prod"
    "Operations Team"  = "Azure Engineering"
    Project            = "04 - project04"
    Region             = "East US 2"
    "Service Hours"    = "n/a"
    "Service Level"    = "n/a"
    Tooling            = "Terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  location = local.rg_location
  name     = local.rg_name
  tags     = local.tags
}

resource "azurerm_data_factory" "rg" {
  location                        = azurerm_resource_group.rg.location
  managed_virtual_network_enabled = false
  name                            = local.df_name
  public_network_enabled          = true
  resource_group_name             = azurerm_resource_group.rg.name
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}

resource "azurerm_mssql_server" "rg" {
  connection_policy                    = "Default"
  location                             = azurerm_resource_group.rg.location
  minimum_tls_version                  = "1.2"
  name                                 = local.mssql_name
  outbound_network_restriction_enabled = false
  primary_user_assigned_identity_id    = null
  public_network_access_enabled        = true
  resource_group_name                  = azurerm_resource_group.rg.name
  version                              = "12.0"
  azuread_administrator {
    azuread_authentication_only = true
    login_username              = "user@example.tld"
    object_id                   = "00000000-0000-0000-0000-000000000000"
    tenant_id                   = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_mssql_database" "rg" {
  auto_pause_delay_in_minutes         = 60
  collation                           = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                         = "Default"
  geo_backup_enabled                  = true
  name                                = local.mssql_dbname
  read_replica_count                  = 0
  read_scale                          = false
  server_id                           = azurerm_mssql_server.rg.id
  storage_account_type                = "Local"
  transparent_data_encryption_enabled = true
  zone_redundant                      = false
}

resource "azurerm_logic_app_standard" "rg" {
  app_service_plan_id = azurerm_app_service_plan.rg.id
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~18"
  }
  bundle_version             = "[1.*, 2.0.0)"
  client_affinity_enabled    = false
  client_certificate_mode    = null
  enabled                    = true
  https_only                 = true
  location                   = azurerm_resource_group.rg.location
  name                       = local.logic_appname
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_access_key = azurerm_storage_account.rg.primary_access_key
  storage_account_name       = azurerm_storage_account.rg.name
  #storage_account_share_name = azurerm_storage_account.rg.storage_account_share_name
  use_extension_bundle = true
  version              = "~4"
  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on                        = false
    app_scale_limit                  = 0
    dotnet_framework_version         = "v6.0"
    elastic_instance_minimum         = 1
    ftps_state                       = "FtpsOnly"
    health_check_path                = null
    http2_enabled                    = false
    ip_restriction                   = []
    linux_fx_version                 = null
    min_tls_version                  = "1.2"
    pre_warmed_instance_count        = 1
    runtime_scale_monitoring_enabled = true
    use_32_bit_worker_process        = false
    vnet_route_all_enabled           = false
    websockets_enabled               = false
    cors {
      allowed_origins     = []
      support_credentials = false
    }
  }
}

resource "azurerm_storage_account" "rg" {
  access_tier                       = null
  account_kind                      = "Storage"
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  allow_nested_items_to_be_public   = false
  edge_zone                         = null
  enable_https_traffic_only         = true
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  large_file_share_enabled          = null
  location                          = azurerm_resource_group.rg.location
  min_tls_version                   = "TLS1_2"
  name                              = local.sa_name
  nfsv3_enabled                     = false
  queue_encryption_key_type         = "Service"
  resource_group_name               = azurerm_resource_group.rg.name
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  blob_properties {
    change_feed_enabled      = false
    default_service_version  = null
    last_access_time_enabled = false
    versioning_enabled       = false
  }
  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_app_service_plan" "rg" {
  app_service_environment_id   = null
  is_xenon                     = false
  kind                         = "elastic"
  location                     = azurerm_resource_group.rg.location
  maximum_elastic_worker_count = 20
  name                         = local.asp_name
  per_site_scaling             = false
  reserved                     = false
  resource_group_name          = azurerm_resource_group.rg.name
  zone_redundant               = false
  sku {
    capacity = 1
    size     = "WS1"
    tier     = "WorkflowStandard"
  }
}
