resource "azurerm_cdn_frontdoor_profile" "afd" {
  name                = "afd${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_custom_domain" "b2c_masq" {
  name                     = "afd-login-domain${local.resource_template}001"
  host_name                = "login.ptpirr-t-s-eu-001.${data.azurerm_dns_zone.devdns.name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_dns_a_record" "test" {
  provider            = azurerm.platform
  name                = "login.ptpirr-t-s-eu-001"
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  zone_name           = data.azurerm_dns_zone.devdns.name
  ttl                 = 300
  target_resource_id  = azurerm_cdn_frontdoor_endpoint.endpoint.id

  depends_on = [azurerm_cdn_frontdoor_origin.b2c]
}

resource "azurerm_dns_txt_record" "validation" {
  provider            = azurerm.platform
  name                = "_dnsauth.login.ptpirr-t-s-eu-001"
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  zone_name           = data.azurerm_dns_zone.devdns.name
  record {
    value = azurerm_cdn_frontdoor_custom_domain.b2c_masq.validation_token
  }
  ttl = 300
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "afd-endpoint${local.resource_template}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id
}

resource "azurerm_cdn_frontdoor_origin_group" "b2c" {
  name                     = "afd-origingroup${local.resource_template}001"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    protocol            = "Http"
    interval_in_seconds = 100
  }

  session_affinity_enabled = false
}

resource "azurerm_cdn_frontdoor_origin" "b2c" {
  name                           = "afd-origin${local.resource_template}001"
  host_name                      = azurerm_aadb2c_directory.b2c.domain_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.b2c.id
  certificate_name_check_enabled = true

  http_port          = 80
  https_port         = 443
  origin_host_header = azurerm_aadb2c_directory.b2c.domain_name
  priority           = 1
  weight             = 1000
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "b2c" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.b2c_masq.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.route.id]
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "afd-route${local.resource_template}001"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.b2c.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.b2c.id]
  cdn_frontdoor_rule_set_ids    = []
  enabled                       = true

  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.b2c_masq.id]
  link_to_default_domain          = true

  depends_on = [azurerm_cdn_frontdoor_origin_group.b2c, azurerm_cdn_frontdoor_origin.b2c]
}
