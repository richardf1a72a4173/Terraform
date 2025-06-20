resource "azurerm_dns_a_record" "test" {
  provider            = azurerm.platform
  name                = "${local.safe_basename}001"
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  zone_name           = data.azurerm_dns_zone.devdns.name
  ttl                 = 300
  target_resource_id  = azurerm_cdn_frontdoor_endpoint.endpoint.id

  depends_on = [azurerm_cdn_frontdoor_origin.test]
}

resource "azurerm_dns_txt_record" "validation" {
  provider            = azurerm.platform
  name                = "_dnsauth.${local.safe_basename}001"
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  zone_name           = data.azurerm_dns_zone.devdns.name
  record {
    value = azurerm_cdn_frontdoor_custom_domain.test.validation_token
  }
  ttl = 300
}

resource "azurerm_cdn_frontdoor_profile" "afd" {
  name                = "afd${local.resource_template}001"
  resource_group_name = azurerm_resource_group.us.name
  sku_name            = "Premium_AzureFrontDoor"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "test" {
  name                     = "afd-custom-domain${local.resource_template}001"
  host_name                = "${local.safe_basename}001.${data.azurerm_dns_zone.devdns.name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "afd-endpoint${local.resource_template}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "test" {
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

resource "azurerm_cdn_frontdoor_origin" "test" {
  name                           = "afd-origin${local.resource_template}001"
  host_name                      = azurerm_windows_web_app.us.default_hostname
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.test.id
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
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "test" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.test.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.route.id]
}

resource "azurerm_cdn_frontdoor_rule_set" "test" {
  name                     = "afdruleset${local.safe_basename}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "afd-route${local.resource_template}001"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.test.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.test.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.test.id]
  enabled                       = true

  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.test.id]
  link_to_default_domain          = true

  depends_on = [azurerm_cdn_frontdoor_origin_group.test]
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
}

resource "azurerm_cdn_frontdoor_security_policy" "waf" {
  name                     = "afd-policy${local.resource_template}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.firewall.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.test.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
