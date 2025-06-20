# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Dev"
project_tag     = "project02"
app_name        = "project02 Dev"
project_code    = "P02"

confidentiality = "Highly Confidential"
country_tag     = "eu"
region          = "westeurope"

# b2c_users = {
#   "chris" = {
#     upn          = "cadmin"
#     display_name = "Chris (Local Admin)"
#     mail = "chris@example.tld"
#   }
#   "rod" = {
#     upn          = "radmin"
#     display_name = "Rod (Local Admin)"
#     mail = "rod@example.tld"
#   }
#   "michiel" = {
#     upn          = "madmin"
#     display_name = "Michiel (Local Admin)"
#     mail = "michiel@example.tld"
#   }
#   "dimitri" = {
#     upn          = "dadmin"
#     display_name = "Dimitri (Local Admin)"
#     mail = "dimitri@example.tld"
#   }
# }

plan_sku_name = "P2v3"
os_plan_type  = "Linux"

vnet_subnet  = "10.201.9.0/25"
snet_subnets = ["10.201.9.0/27", "10.201.9.32/27", "10.201.9.64/27", "10.201.9.96/27"]

iam_rbac_role = "Reader"
# iam_rbac_member          = ""
iam_rbac_member_id       = ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000"]
iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
group_rbac_change_record = "CHG0032334"

mysql_admin    = "mysql_admin"
mysql_password = "<pass>"

nsg_map_pe = {
  200 = {
    name                    = "AllowHTTP"
    priority                = "200"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "80"
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }
  210 = {
    name                    = "AllowHTTPS"
    priority                = "210"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "443"
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
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
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
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
}
