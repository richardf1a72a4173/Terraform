terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
  }

  required_version = ">= 1.7.0"
}

provider "azurerm" {
  subscription_id = local.sub_id
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  location = "uksouth"
  name     = "rg-project01-waf-p-001"
  tags     = local.tags
}

resource "azurerm_virtual_network" "rg" {
  address_space       = ["10.201.237.0/26"]
  location            = azurerm_resource_group.rg.location
  name                = "vnet-project01-waf-p-001"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "frontend" {
  address_prefixes     = ["10.201.237.0/27"]
  name                 = "snet-project01-waf-p-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
}

resource "azurerm_subnet" "backend" {
  address_prefixes     = ["10.201.237.32/27"]
  name                 = "snet-project01-waf-p-002"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
}

resource "azurerm_key_vault" "rg" {
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  location                        = azurerm_resource_group.rg.location
  name                            = "kv-project01-waf-p-001"
  purge_protection_enabled        = false
  resource_group_name             = azurerm_resource_group.rg.name
  sku_name                        = "standard"
  soft_delete_retention_days      = 90
  tenant_id                       = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_application_gateway" "rg" {
  enable_http2                      = true
  fips_enabled                      = false
  firewall_policy_id                = azurerm_web_application_firewall_policy.rg.id
  force_firewall_policy_association = false
  location                          = azurerm_resource_group.rg.location
  name                              = "ag-project01-waf-p-001"
  resource_group_name               = azurerm_resource_group.rg.name
  tags                              = {}
  zones                             = ["1", "2", "3"]
  autoscale_configuration {
    max_capacity = 10
    min_capacity = 0
  }
  backend_address_pool {
    fqdns        = ["project01.azurewebsites.net"]
    ip_addresses = []
    name         = "eproject01"
  }
  backend_address_pool {
    fqdns        = ["project01api.azurewebsites.net"]
    ip_addresses = []
    name         = "project01-api"
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    host_name                           = null
    name                                = "project01"
    path                                = null
    pick_host_name_from_backend_address = false
    port                                = 443
    probe_name                          = null
    protocol                            = "Https"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    host_name                           = null
    name                                = "project01-api"
    path                                = null
    pick_host_name_from_backend_address = false
    port                                = 443
    probe_name                          = null
    protocol                            = "Https"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }
  frontend_ip_configuration {
    name                            = "appGwPublicFrontendIpIPv4"
    private_ip_address              = null
    private_ip_address_allocation   = "Dynamic"
    private_link_configuration_name = null
    public_ip_address_id            = azurerm_public_ip.rg.id
    subnet_id                       = null
  }
  frontend_port {
    name = "port_443"
    port = 443
  }
  frontend_port {
    name = "port_80"
    port = 80
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.frontend.id
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = "project01.domain.tld"
    host_names                     = []
    name                           = "project01-api-ssl"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL"
    ssl_profile_name               = null
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = "project01.domain.tld"
    host_names                     = []
    name                           = "project01-ssl"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL"
    ssl_profile_name               = null
  }
  identity {
    identity_ids = ["${azurerm_user_assigned_identity.rg.id}"]
    type         = "UserAssigned"
  }
  request_routing_rule {
    backend_address_pool_name   = "project01"
    backend_http_settings_name  = "project01"
    http_listener_name          = "project01-ssl"
    name                        = "project01"
    priority                    = 10
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  request_routing_rule {
    backend_address_pool_name   = "project01-api"
    backend_http_settings_name  = "project01-api"
    http_listener_name          = "project01-api-ssl"
    name                        = "project01"
    priority                    = 20
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  sku {
    capacity = 0
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }
}

resource "azurerm_web_application_firewall_policy" "rg" {
  location            = azurerm_resource_group.rg.location
  name                = "waf-project01-waf-p-001"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = {}
  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = jsonencode(3.2)
    }
  }
  policy_settings {
    enabled                     = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
    mode                        = "Detection"
    request_body_check          = true
  }
}

resource "azurerm_public_ip" "rg" {
  allocation_method       = "Static"
  domain_name_label       = null
  edge_zone               = null
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = azurerm_resource_group.rg.location
  name                    = "pip-project01-waf-p-001"
  public_ip_prefix_id     = null
  resource_group_name     = azurerm_resource_group.rg.name
  reverse_fqdn            = null
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = ["1", "2", "3"]
}

resource "azurerm_private_endpoint" "web" {
  location            = azurerm_resource_group.rg.location
  name                = "pe-project01-p-001"
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.backend.id
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["${azurerm_private_dns_zone.rg.id}"]
  }
  private_service_connection {
    is_manual_connection              = false
    name                              = "pe-project01-p-001-a887"
    private_connection_resource_alias = null
    private_connection_resource_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/project01-Staging/providers/Microsoft.Web/sites/project01"
    request_message                   = null
    subresource_names                 = ["sites"]
  }
}

resource "azurerm_private_endpoint" "api" {
  location            = azurerm_resource_group.rg.location
  name                = "pe-project01api-p-001"
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.backend.id
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["${azurerm_private_dns_zone.rg.id}"]
  }
  private_service_connection {
    is_manual_connection              = false
    name                              = "pe-project01api-p-001-86da"
    private_connection_resource_alias = null
    private_connection_resource_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/project01-Staging/providers/Microsoft.Web/sites/project01api"
    request_message                   = null
    subresource_names                 = ["sites"]
  }
}

resource "azurerm_network_interface" "web" {
  edge_zone               = null
  internal_dns_name_label = null
  location                = azurerm_resource_group.rg.location
  name                    = "pe-project01-p-001.nic.00000000-0000-0000-0000-000000000000"
  resource_group_name     = azurerm_resource_group.rg.name
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "privateEndpointIpConfig.00000000-0000-0000-0000-000000000000"
    primary                                            = true
    private_ip_address                                 = "10.201.237.36"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = null
    subnet_id                                          = azurerm_subnet.backend.id
  }
}

resource "azurerm_network_interface" "api" {
  edge_zone               = null
  internal_dns_name_label = null
  location                = azurerm_resource_group.rg.location
  name                    = "pe-project01api-p-001.nic.00000000-0000-0000-0000-000000000000"
  resource_group_name     = azurerm_resource_group.rg.name
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "privateEndpointIpConfig.00000000-0000-0000-0000-000000000000"
    primary                                            = true
    private_ip_address                                 = "10.201.237.37"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = null
    subnet_id                                          = azurerm_subnet.backend.id
  }
}

resource "azurerm_private_dns_zone" "rg" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
  soa_record {
    email        = "azureprivatedns-host.microsoft.com"
    expire_time  = 2419200
    minimum_ttl  = 10
    refresh_time = 3600
    retry_time   = 300
    tags         = {}
    ttl          = 3600
  }
}

resource "azurerm_user_assigned_identity" "rg" {
  location            = azurerm_resource_group.rg.location
  name                = "id-project01-waf-p-001"
  resource_group_name = azurerm_resource_group.rg.name
}
