resource "azurerm_user_assigned_identity" "ag" {
  name                = "uai-ag${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "waf${local.resource_template}001"
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
    file_upload_limit_in_mb     = 275
    max_request_body_size_in_kb = 128
    mode                        = "Prevention"
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
  name                = "ag${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  zones               = ["1", "2", "3"]

  autoscale_configuration {
    max_capacity = local.env == "p" ? 5 : 2
    min_capacity = local.env == "p" ? 2 : 0
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

  # START HOSTNAME CONFIG

  # START MAIN CONFIG
  backend_address_pool {
    fqdns        = [azurerm_linux_web_app.app.default_hostname]
    ip_addresses = []
    name         = "app-backendpool${local.resource_template}001"
  }
  # Main Site Backend
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
  # Main Site Listener
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = null
    host_names                     = [var.http_hostname, var.http_hostname_2]
    name                           = "https-listener-app${local.resource_template}001"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "pfx-wildcard"
    ssl_profile_name               = null
  }
  # HTTP Listener Main
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = null
    host_names                     = [var.http_hostname, var.http_hostname_2]
    name                           = "http-listener-app${local.resource_template}001"
    protocol                       = "Http"
  }
  # Routing Rule Main Site
  request_routing_rule {
    backend_address_pool_name   = "app-backendpool${local.resource_template}001"
    backend_http_settings_name  = "backend-httpsettings-app${local.resource_template}001"
    http_listener_name          = "https-listener-app${local.resource_template}001"
    name                        = "https-rrr-app${local.resource_template}001"
    priority                    = 30
    redirect_configuration_name = null
    rewrite_rule_set_name       = "ag-rewrite${local.resource_template}002"
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  # Routing Rule HTTP
  request_routing_rule {
    http_listener_name          = "http-listener-app${local.resource_template}001"
    name                        = "http-rrr-app${local.resource_template}001"
    priority                    = 20
    redirect_configuration_name = "http-rrr-app${local.resource_template}001"
    rewrite_rule_set_name       = "ag-rewrite${local.resource_template}001"
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  # HTTPS Upgrade
  redirect_configuration {
    name                 = "http-rrr-app${local.resource_template}001"
    include_path         = true
    include_query_string = true
    redirect_type        = "Permanent"
    target_listener_name = "https-listener-app${local.resource_template}001"
  }
  # END MAIN CONFIG

  # START STG CONFIG
  backend_address_pool {
    fqdns        = [azurerm_linux_web_app_slot.staging.default_hostname]
    ip_addresses = []
    name         = "stg-backendpool${local.resource_template}002"
  }
  # Main Site Backend
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    host_name                           = null
    name                                = "backend-httpsettings-stg${local.resource_template}002"
    path                                = null
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = null
    protocol                            = "Https"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }
  # Main Site Listener
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = null
    host_names                     = ["stg.${var.http_hostname}", "stg-${var.http_hostname_2}"]
    name                           = "https-listener-stg${local.resource_template}004"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "pfx-wildcard"
    ssl_profile_name               = null
  }
  # HTTP Listener Main
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = null
    host_names                     = ["stg.${var.http_hostname}", "stg-${var.http_hostname_2}"]
    name                           = "http-listener-stg${local.resource_template}004"
    protocol                       = "Http"
  }
  # Routing Rule Main Site
  request_routing_rule {
    backend_address_pool_name   = "stg-backendpool${local.resource_template}002"
    backend_http_settings_name  = "backend-httpsettings-stg${local.resource_template}002"
    http_listener_name          = "https-listener-stg${local.resource_template}004"
    name                        = "https-rrr-stg${local.resource_template}004"
    priority                    = 60
    redirect_configuration_name = null
    rewrite_rule_set_name       = "ag-rewrite${local.resource_template}002"
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  # Routing Rule HTTP
  request_routing_rule {
    http_listener_name          = "http-listener-stg${local.resource_template}004"
    name                        = "http-rrr-stg${local.resource_template}004"
    priority                    = 40
    redirect_configuration_name = "http-rrr-stg${local.resource_template}004"
    rewrite_rule_set_name       = "ag-rewrite${local.resource_template}001"
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  # HTTPS Upgrade
  redirect_configuration {
    name                 = "http-rrr-stg${local.resource_template}004"
    include_path         = true
    include_query_string = true
    redirect_type        = "Permanent"
    target_listener_name = "https-listener-stg${local.resource_template}004"
  }
  # END STG CONFIG

  # # START OLD. CONFIG
  # # Old. Proxy Backend
  # backend_address_pool {
  #   fqdns        = []
  #   ip_addresses = [""]
  #   name         = "old-backendpool${local.resource_template}003"
  # }
  # # Old. Proxy Backend Hostname Override
  # backend_http_settings {
  #   affinity_cookie_name                = "ApplicationGatewayAffinity"
  #   cookie_based_affinity               = "Disabled"
  #   host_name                           = var.http_hostname
  #   name                                = "backend-httpsettings-old${local.resource_template}003"
  #   path                                = null
  #   pick_host_name_from_backend_address = false
  #   port                                = 443
  #   probe_name                          = null
  #   protocol                            = "Https"
  #   request_timeout                     = 20
  #   trusted_root_certificate_names      = []
  # }
  # # HTTPS Listener Old.
  # http_listener {
  #   firewall_policy_id             = null
  #   frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
  #   frontend_port_name             = "port_443"
  #   host_name                      = "old.${var.http_hostname}"
  #   host_names                     = null
  #   name                           = "https-listener-old${local.resource_template}003"
  #   protocol                       = "Https"
  #   require_sni                    = true
  #   ssl_certificate_name           = "pfx-wildcard"
  #   ssl_profile_name               = null
  # }
  # # HTTP Listener Old.
  # http_listener {
  #   firewall_policy_id             = null
  #   frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
  #   frontend_port_name             = "port_80"
  #   host_name                      = "old.${var.http_hostname}"
  #   host_names                     = null
  #   name                           = "http-listener-old${local.resource_template}003"
  #   protocol                       = "Http"
  # }
  # # Backend Routing Old.
  # request_routing_rule {
  #   backend_address_pool_name   = "old-backendpool${local.resource_template}003"
  #   backend_http_settings_name  = "backend-httpsettings-old${local.resource_template}003"
  #   http_listener_name          = "https-listener-old${local.resource_template}003"
  #   name                        = "https-rrr-old${local.resource_template}003"
  #   priority                    = 32
  #   redirect_configuration_name = null
  #   rewrite_rule_set_name       = "ag-rewrite${local.resource_template}003"
  #   rule_type                   = "Basic"
  #   url_path_map_name           = null
  # }
  # # HTTPS Upgrade Old.
  # request_routing_rule {
  #   http_listener_name          = "http-listener-old${local.resource_template}003"
  #   name                        = "http-rrr-old${local.resource_template}003"
  #   priority                    = 22
  #   redirect_configuration_name = "http-rrr-old${local.resource_template}003"
  #   rewrite_rule_set_name       = "ag-rewrite${local.resource_template}001"
  #   rule_type                   = "Basic"
  #   url_path_map_name           = null
  # }
  # # HTTPS Upgrade Old.
  # redirect_configuration {
  #   name                 = "http-rrr-old${local.resource_template}003"
  #   include_path         = true
  #   include_query_string = true
  #   redirect_type        = "Permanent"
  #   target_listener_name = "https-listener-old${local.resource_template}003"
  # }
  # # END OLD. CONFIG

  # END HOSTNAME CONFIGS

  identity {
    identity_ids = [azurerm_user_assigned_identity.ag.id]
    type         = "UserAssigned"
  }

  ssl_certificate {
    name                = "pfx-wildcard"
    key_vault_secret_id = "https://kv-project02-p-s-eu-001.vault.azure.net/secrets/wildcard-pfx"
    # data     = acme_certificate.cert.certificate_p12
    # password = acme_certificate.cert.certificate_p12_password
  }

  ssl_policy {
    policy_name = "AppGwSslPolicy20220101"
    policy_type = "Predefined"
  }

  rewrite_rule_set {
    name = "ag-rewrite${local.resource_template}001"
    rewrite_rule {
      name          = "HSTS-Rewrite"
      rule_sequence = 100
      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubdomains"
      }
    }
    rewrite_rule {
      name          = "Remove-Server"
      rule_sequence = 125
      response_header_configuration {
        header_name  = "Server"
        header_value = ""
      }
    }
  }

  rewrite_rule_set {
    name = "ag-rewrite${local.resource_template}002"
    rewrite_rule {
      name          = "HSTS-Rewrite"
      rule_sequence = 125
      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubdomains"
      }
    }
    rewrite_rule {
      name          = "Remove-X-Powered-By"
      rule_sequence = 150
      response_header_configuration {
        header_name  = "X-Powered-By"
        header_value = ""
      }
    }
    rewrite_rule {
      name          = "Remove-Server"
      rule_sequence = 175
      response_header_configuration {
        header_name  = "Server"
        header_value = ""
      }
    }
  }

  # rewrite_rule_set {
  #   name = "ag-rewrite${local.resource_template}003"
  #   rewrite_rule {
  #     name          = "HSTS-Rewrite"
  #     rule_sequence = 100
  #     response_header_configuration {
  #       header_name  = "Strict-Transport-Security"
  #       header_value = "max-age=31536000; includeSubdomains"
  #     }
  #   }
  #   rewrite_rule {
  #     name          = "Remove-content-security-policy"
  #     rule_sequence = 125
  #     response_header_configuration {
  #       header_name  = "content-security-policy"
  #       header_value = ""
  #     }
  #   }
  #   rewrite_rule {
  #     name          = "Remove-X-Powered-By"
  #     rule_sequence = 150
  #     response_header_configuration {
  #       header_name  = "X-Powered-By"
  #       header_value = ""
  #     }
  #   }
  #   rewrite_rule {
  #     name          = "Remove-Server"
  #     rule_sequence = 175
  #     response_header_configuration {
  #       header_name  = "Server"
  #       header_value = ""
  #     }
  #   }
  # }

  sku {
    capacity = 0
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  # depends_on = [azurerm_network_security_group.nsg, azurerm_network_security_rule.appgw-loadbalancer, acme_certificate.cert]

  lifecycle {
    ignore_changes = [tags]
  }
}
