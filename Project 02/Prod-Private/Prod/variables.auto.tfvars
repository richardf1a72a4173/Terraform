# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Prod"
project_tag     = "project02"
app_name        = "project02 Dev"
project_code    = "02"

confidentiality = "Highly Confidential"
country_tag     = "eu"
region          = "westeurope"

plan_sku_name = "P2v3"
os_plan_type  = "Linux"

vnet_subnet  = "10.201.10.0/25"
snet_subnets = ["10.201.10.0/27", "10.201.10.32/27", "10.201.10.64/27", "10.201.10.96/27"]

iam_rbac_role            = "Reader"
iam_rbac_member_id       = ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000"]
iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
group_rbac_change_record = "CHG"

dev_ip = ""

mysql_admin    = "<user>"
mysql_password = "<pass>"

http_hostname   = "project02.com"
http_hostname_2 = "project02.<domain>.com"

waf_exclusions = {
  0 = {
    match_variable          = "RequestArgNames"
    selector                = "data"
    selector_match_operator = "StartsWith"
  }
  1 = {
    match_variable          = "RequestArgNames"
    selector                = "props"
    selector_match_operator = "StartsWith"
  }
  2 = {
    match_variable          = "RequestArgNames"
    selector                = "sponsors"
    selector_match_operator = "StartsWith"
  }
  3 = {
    match_variable          = "RequestArgNames"
    selector                = "kit"
    selector_match_operator = "StartsWith"
  }
  4 = {
    match_variable          = "RequestArgNames"
    selector                = "page"
    selector_match_operator = "StartsWith"
  }
  5 = {
    match_variable          = "RequestArgNames"
    selector                = "news_item"
    selector_match_operator = "StartsWith"
  }
  6 = {
    match_variable          = "RequestArgNames"
    selector                = "ticket"
    selector_match_operator = "StartsWith"
  }
  7 = {
    match_variable          = "RequestArgNames"
    selector                = "faq_item"
    selector_match_operator = "StartsWith"
  }
  8 = {
    match_variable          = "RequestCookieNames"
    selector                = "sf_redirect"
    selector_match_operator = "StartsWith"
  }
  9 = {
    match_variable          = "RequestCookieNames"
    selector                = "CookieScriptConsent"
    selector_match_operator = "StartsWith"
  }
  10 = {
    match_variable          = "RequestArgNames"
    selector                = "email_template"
    selector_match_operator = "StartsWith"
  }
  11 = {
    match_variable          = "RequestArgNames"
    selector                = "comment"
    selector_match_operator = "StartsWith"
  }
  12 = {
    match_variable          = "RequestArgNames"
    selector                = "order_reject_purchase_order"
    selector_match_operator = "StartsWith"
  }
  13 = {
    match_variable          = "RequestArgNames"
    selector                = "scheme"
    selector_match_operator = "StartsWith"
  }
  14 = {
    match_variable          = "RequestArgNames"
    selector                = "bulk_email"
    selector_match_operator = "StartsWith"
  }
  15 = {
    match_variable          = "RequestArgKeys"
    selector                = "session_id"
    selector_match_operator = "StartsWith"
  }
  16 = {
    match_variable          = "RequestHeaderValues"
    selector                = "checkout.stripe.com"
    selector_match_operator = "Contains"
  }
  17 = {
    match_variable          = "RequestArgNames"
    selector                = "error_description"
    selector_match_operator = "StartsWith"
  }
  18 = {
    match_variable          = "RequestArgNames"
    selector                = "product"
    selector_match_operator = "StartsWith"
  }
  19 = {
    match_variable          = "RequestArgNames"
    selector                = "g-recaptcha-response"
    selector_match_operator = "StartsWith"
  }
  20 = {
    match_variable          = "RequestArgNames"
    selector                = "h-capthca-response"
    selector_match_operator = "StartsWith"
  }
  21 = {
    match_variable          = "RequestArgNames"
    selector                = "contact"
    selector_match_operator = "StartsWith"
  }
}

nsg_map_pe = {
  200 = {
    name                    = "AllowHTTP"
    priority                = "200"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "80"
    source_address_prefixes = ["10.201.10.0/25", "10.200.252.0/24"]
  }
  210 = {
    name                    = "AllowHTTPS"
    priority                = "210"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "443"
    source_address_prefixes = ["10.201.10.0/25", "10.200.252.0/24"]
  }
  4000 = {
    name                    = "DenyInbound"
    priority                = "4000"
    direction               = "Inbound"
    access                  = "Deny"
    protocol                = "*"
    destination_port_range  = "*"
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }
}

nsg_map_sql = {
  200 = {
    name                    = "AllowSQL"
    priority                = "200"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "3306"
    source_address_prefixes = ["10.201.10.0/25", "10.200.252.0/24"]
  }
  4000 = {
    name                    = "DenyInbound"
    priority                = "4000"
    direction               = "Inbound"
    access                  = "Deny"
    protocol                = "*"
    destination_port_range  = "*"
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }

}

nsg_map_appservice = {
  4000 = {
    name                    = "DenyInbound"
    priority                = "4000"
    direction               = "Inbound"
    access                  = "Deny"
    protocol                = "*"
    destination_port_range  = "*"
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }
}

public_dns_txt_records = {
  3 = {
    name   = "mimecast20190227._domainkey"
    record = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzuRkgULKOesIvd2QO7CHPalW2iCknaoG0LuM0JZW/K0HctKf3sufrM6fF1eOYvvXoGn7/emlu+8BJRGqR44ZCpUPmrpmhHTtDXkMyeUTn2OT3+OzmKrJahvOAnU1cldE6B7Nnf/v1VOFzXU+E6e39ea+E2Jc7jojEt1c5WpFZaAmjWPsLE3rScuMGEEIbe/TA"
  }
  4 = {
    name   = "_dmarc"
    record = "v=DMARC1; p=reject; rua=mailto:3d0f96587246827@rep.dmarcanalyzer.com; ruf=mailto:3d0f96587246827@for.dmarcanalyzer.com; fo=1;"
  }
  6 = {
    name   = "mail._domainkey"
    record = "k=rsa;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeMVIzrCa3T14JsNY0IRv5/2V1/v2itlviLQBwXsa7shBD6TrBkswsFUToPyMRWC9tbR/5ey0nRBH0ZVxp+lsmTxid2Y2z+FApQ6ra2VsXfbJP3HE6wAO0YTVEJt1TmeczhEd2Jiz/fcabIISgXEdSpTYJhb0ct0VJRxcg4c8c7wIDAQAB"
  }
  8 = {
    name   = "cm._domainkey"
    record = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC2+PG7gXexgB5SWxqHhwC4KHdkj/sFijym1YBfkOvMw+1s77e5ntYEZjhoXc03X6kL7SHPqQtOViXH/zwxDxJHje2WGlkiz0k4i2yxadEk4ps3rO8GD5m9oapqQ+7YCaO+MMQRCxvFFAfpwopBNYuA/9/WhSbkkbHrxTWS+GK8/wIDAQAB"
  }
  9 = {
    name   = "_dnsauth.login.ptpscheme.com"
    record = "_50cgqhpsoi7kaxcene9m9ljhcnodscj"
  }
}

public_dns_a_records = {
  1 = {
    name   = "new"
    record = "185.31.40.22"
  }
  2 = {
    name   = "newsite"
    record = "134.19.161.6"
  }
  3 = {
    name   = "old"
    record = "134.19.161.15"
  }
}
