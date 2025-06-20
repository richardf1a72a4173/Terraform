resource "azurerm_user_assigned_identity" "ag" {
  name                = local.ag_mi_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_web_application_firewall_policy" "waf" {
  name                = local.waf_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  managed_rules {
    managed_rule_set {
      type    = "Microsoft_DefaultRuleSet"
      version = "2.1"
    }
    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "1.1"
    }

    dynamic "exclusion" {
      for_each = var.waf_exclusions

      content {
        match_variable          = exclusion.value.match_variable
        selector                = exclusion.value.selector
        selector_match_operator = exclusion.value.selector_match_operator
      }
    }
  }

  policy_settings {
    enabled                     = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
    mode                        = "Detection"
    request_body_check          = true
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_gateway" "ag" {
  enable_http2        = true
  fips_enabled        = false
  firewall_policy_id  = azurerm_web_application_firewall_policy.waf.id
  location            = azurerm_resource_group.rg.location
  name                = local.ag_name
  resource_group_name = azurerm_resource_group.rg.name
  zones               = ["1", "2", "3"]
  autoscale_configuration {
    max_capacity = local.env == "p" ? 5 : 2
    min_capacity = local.env == "p" ? 2 : 0
  }
  backend_address_pool {
    fqdns        = [azurerm_linux_web_app.app.default_hostname]
    ip_addresses = []
    name         = "app-backendpool${local.resource_template}001"
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    host_name                           = null
    name                                = "backend-httpsettings-app${local.resource_template}001"
    path                                = null
    pick_host_name_from_backend_address = true
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
    public_ip_address_id            = azurerm_public_ip.pip.id
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
    subnet_id = azurerm_subnet.app-gw.id
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = local.app_hostname
    host_names                     = []
    name                           = "https-listener-app${local.resource_template}001"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = data.azurerm_key_vault_secret.ssl.name
    ssl_profile_name               = null
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = local.app_hostname_2
    host_names                     = []
    name                           = "https-listener-app${local.resource_template}002"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = data.azurerm_key_vault_secret.ssl2.name
    ssl_profile_name               = null
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = local.app_hostname
    host_names                     = []
    name                           = "http-listener-app${local.resource_template}001"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = local.app_hostname_2
    host_names                     = []
    name                           = "http-listener-app${local.resource_template}002"
    protocol                       = "Http"
  }
  identity {
    identity_ids = [azurerm_user_assigned_identity.ag.id]
    type         = "UserAssigned"
  }
  ssl_certificate {
    key_vault_secret_id = data.azurerm_key_vault_secret.ssl.versionless_id
    name                = data.azurerm_key_vault_secret.ssl.name
  }
  ssl_certificate {
    key_vault_secret_id = data.azurerm_key_vault_secret.ssl2.versionless_id
    name                = data.azurerm_key_vault_secret.ssl2.name
  }
  request_routing_rule {
    backend_address_pool_name   = "app-backendpool${local.resource_template}001"
    backend_http_settings_name  = "backend-httpsettings-app${local.resource_template}001"
    http_listener_name          = "https-listener-app${local.resource_template}001"
    name                        = "https-rrr-app${local.resource_template}001"
    priority                    = 30
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  request_routing_rule {
    backend_address_pool_name   = "app-backendpool${local.resource_template}001"
    backend_http_settings_name  = "backend-httpsettings-app${local.resource_template}001"
    http_listener_name          = "https-listener-app${local.resource_template}002"
    name                        = "https-rrr-app${local.resource_template}002"
    priority                    = 31
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  # HTTPS Automatic Upgrade
  request_routing_rule {
    http_listener_name          = "http-listener-app${local.resource_template}001"
    name                        = "http-rrr-app${local.resource_template}001"
    priority                    = 20
    redirect_configuration_name = "http-rrr-app${local.resource_template}001"
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  redirect_configuration {
    name                 = "http-rrr-app${local.resource_template}001"
    include_path         = true
    include_query_string = true
    redirect_type        = "Permanent"
    target_listener_name = "https-listener-app${local.resource_template}001"
  }
  request_routing_rule {
    http_listener_name          = "http-listener-app${local.resource_template}002"
    name                        = "http-rrr-app${local.resource_template}002"
    priority                    = 21
    redirect_configuration_name = "http-rrr-app${local.resource_template}002"
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  redirect_configuration {
    name                 = "http-rrr-app${local.resource_template}002"
    include_path         = true
    include_query_string = true
    redirect_type        = "Permanent"
    target_listener_name = "https-listener-app${local.resource_template}002"
  }
  sku {
    capacity = 0
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  depends_on = [azurerm_network_security_group.nsg, azurerm_network_security_rule.appgw-loadbalancer]

  lifecycle {
    ignore_changes = [tags]
  }
}
