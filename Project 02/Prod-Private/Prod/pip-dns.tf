resource "azurerm_public_ip" "pip" {
  name                 = "pip${local.resource_template}001"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  allocation_method    = "Static"
  zones                = ["1", "2", "3"]
  sku                  = "Standard"
  ddos_protection_mode = "Enabled"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_dns_zone" "ptpscheme" {
  name                = var.http_hostname
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_management_lock" "pip" {
  name       = "PIP"
  scope      = azurerm_public_ip.pip.id
  lock_level = "CanNotDelete"
  notes      = "Delete Resource Lock"
}

resource "azurerm_management_lock" "dns" {
  name       = "DNS"
  scope      = azurerm_dns_zone.ptpscheme.id
  lock_level = "CanNotDelete"
  notes      = "Delete Resource Lock"
}

resource "azurerm_dns_a_record" "h1" {
  name                = "@"
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_dns_zone.ptpscheme.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}

resource "azurerm_dns_a_record" "h2" {
  name                = "proficiencypulse"
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_dns_zone.ptpscheme.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}

# resource "azurerm_dns_a_record" "old" {
#   name                = "old"
#   resource_group_name = azurerm_resource_group.rg.name
#   zone_name           = azurerm_dns_zone.ptpscheme.name
#   ttl                 = 300
#   target_resource_id  = azurerm_public_ip.pip.id
# }

resource "azurerm_dns_a_record" "stg" {
  name                = "stg"
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_dns_zone.ptpscheme.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}

resource "azurerm_dns_a_record" "stgpp" {
  name                = "stg-proficiencypulse"
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_dns_zone.ptpscheme.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}

resource "azurerm_dns_cname_record" "login" {
  name                = "login"
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_dns_zone.ptpscheme.name
  ttl                 = 300
  target_resource_id  = data.azurerm_cdn_frontdoor_endpoint.endpoint.id
}

resource "azurerm_dns_txt_record" "txt" {
  for_each            = var.public_dns_txt_records
  zone_name           = azurerm_dns_zone.ptpscheme.name
  resource_group_name = azurerm_resource_group.rg.name
  name                = each.value.name
  record {
    value = each.value.record
  }
  ttl = 300
}

resource "azurerm_dns_txt_record" "naked" {
  zone_name           = azurerm_dns_zone.ptpscheme.name
  resource_group_name = azurerm_resource_group.rg.name
  name                = "@"
  record {
    value = "v=spf1 include:spf.us.exclaimer.net include:spf.protection.outlook.com include:eu._netblocks.mimecast.com include:spf.sendinblue.com include:_spf.createsend.com ip4:77.32.148.0/24 ip4:185.41.28.0/24 ip4:1.179.112.0/20 mx -all"
  }
  record {
    value = "0ed1fe018a31788f2417fe4ce8a620cb8bbb6cd80a"
  }
  record {
    value = "OAWlXZHwcn+tsOwX7iZLYuaR1yoIEmAME71S2YKvEZejmBZ/f3maSh/xOmIt4tmKu8J2ujEqzlGBt4CWF6Wiag=="
  }
  record {
    value = "sendinblue-code:2caf6933e4183fd3f45f14df5064667c"
  }
  record {
    value = "MS=ms40676413"
  }
  ttl = 300
}

resource "azurerm_dns_mx_record" "MX" {
  zone_name           = azurerm_dns_zone.ptpscheme.name
  resource_group_name = azurerm_resource_group.rg.name
  name                = "@"
  record {
    preference = 10
    exchange   = "eu-smtp-inbound-1.mimecast.com"
  }
  record {
    preference = 10
    exchange   = "eu-smtp-inbound-2.mimecast.com"
  }
  ttl = 300
}

resource "azurerm_dns_a_record" "a" {
  for_each            = var.public_dns_a_records
  zone_name           = azurerm_dns_zone.ptpscheme.name
  resource_group_name = azurerm_resource_group.rg.name
  name                = each.value.name
  records             = [each.value.record]
  ttl                 = 300
}
