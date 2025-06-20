resource "azurerm_application_gateway" "rg" {
  enable_http2                      = true
  fips_enabled                      = false
  firewall_policy_id                = azurerm_web_application_firewall_policy.rg.id
  force_firewall_policy_association = false
  location                          = azurerm_resource_group.rg.location
  name                              = local.ag_name
  resource_group_name               = azurerm_resource_group.rg.name
  zones                             = ["1", "2", "3"]
  autoscale_configuration {
    max_capacity = 10
    min_capacity = 0
  }
  backend_address_pool {
    fqdns        = ["project01-dev.azurewebsites.net"]
    ip_addresses = []
    name         = "project01"
  }
  backend_address_pool {
    fqdns        = ["project01-dev.azurewebsites.net"]
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
    subnet_id = local.subnets_by_name["${local.vnet_snet_name[2]}"].id
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
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = "project01.domain.tld"
    host_names                     = []
    name                           = "project01-api"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = "project01.domain.tld"
    host_names                     = []
    name                           = "project01"
    protocol                       = "Http"
  }
  identity {
    identity_ids = ["${azurerm_user_assigned_identity.rg.id}"]
    type         = "UserAssigned"
  }
  ssl_certificate {
    key_vault_secret_id = azurerm_key_vault_certificate.kv.secret_id
    name                = "ssl"
  }
  request_routing_rule {
    backend_address_pool_name   = "project01"
    backend_http_settings_name  = "project01"
    http_listener_name          = "project01-ssl"
    name                        = "project01"
    priority                    = 30
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
    priority                    = 40
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  request_routing_rule {
    backend_address_pool_name   = "project01-http"
    backend_http_settings_name  = "project01"
    http_listener_name          = "project01-ssl"
    name                        = "project01-http"
    priority                    = 10
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  request_routing_rule {
    backend_address_pool_name   = "project01-api-http"
    backend_http_settings_name  = "project01-api"
    http_listener_name          = "project01-api-ssl"
    name                        = "project01-http"
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
  name                = local.waf_name
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
  name                    = local.pip_name
  public_ip_prefix_id     = null
  resource_group_name     = azurerm_resource_group.rg.name
  reverse_fqdn            = null
  sku                     = "Standard"
  sku_tier                = "Regional"
  zones                   = ["1", "2", "3"]
}

resource "azurerm_user_assigned_identity" "rg" {
  location            = azurerm_resource_group.rg.location
  name                = local.ua_id_name
  resource_group_name = azurerm_resource_group.rg.name
}
