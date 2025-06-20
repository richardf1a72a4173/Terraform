resource "azurerm_cdn_frontdoor_profile" "afd" {
  name                = module.naming.cdn_profile.name
  resource_group_name = azurerm_resource_group.us.name
  sku_name            = "Premium_AzureFrontDoor"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "prod" {
  name                     = "afd-custom-domain${local.resource_template}001"
  host_name                = var.prod_domain
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }

  depends_on = [azurerm_dns_a_record.prod]
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = module.naming.cdn_endpoint.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "prod" {
  name                     = "afd-origingroup${local.resource_template}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    protocol            = "Https"
    interval_in_seconds = 100
  }

  session_affinity_enabled = false
}

resource "azurerm_cdn_frontdoor_origin" "prod" {
  name                           = "afd-origin${local.resource_template}001"
  host_name                      = azurerm_windows_web_app.us.default_hostname
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.prod.id
  certificate_name_check_enabled = true

  http_port          = 80
  https_port         = 443
  origin_host_header = azurerm_windows_web_app.us.default_hostname
  priority           = 1
  weight             = 1000

  private_link {
    private_link_target_id = azurerm_windows_web_app.us.id
    location               = azurerm_resource_group.us.location
    target_type            = "sites"
  }

  depends_on = [azurerm_cdn_frontdoor_custom_domain.prod]
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "prod" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.prod.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.route.id]
}

resource "azurerm_cdn_frontdoor_rule_set" "prod" {
  name                     = "afdruleset${local.safe_basename}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "afd-route${local.resource_template}001"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.prod.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.prod.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.prod.id]
  enabled                       = true

  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.prod.id]
  link_to_default_domain          = true

  depends_on = [azurerm_cdn_frontdoor_origin_group.prod]
}

resource "azurerm_cdn_frontdoor_firewall_policy" "firewall" {
  name                = "afdwaf${local.safe_basename}001"
  resource_group_name = azurerm_resource_group.us.name
  sku_name            = azurerm_cdn_frontdoor_profile.afd.sku_name
  mode                = "Prevention"

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
    action  = "Block"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "waf" {
  name                     = "afd-policy${local.resource_template}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.firewall.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.prod.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
