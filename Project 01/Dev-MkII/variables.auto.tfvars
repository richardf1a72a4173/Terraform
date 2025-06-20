# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Dev"
project_tag     = "project01"
app_name        = "project01"
project_code    = "P01"
country_tag     = "weu"
region          = "westeurope"

vnet_subnet  = "10.201.124.0/24"
snet_subnets = ["10.201.124.0/26", "10.201.124.64/26", "10.201.124.128/26", "10.201.124.192/26"]
vnet_change  = "CHG"

http_hostname   = ""
http_hostname_2 = ""

sql_admin           = "admin@example.tld"
sql_admin_object_id = "00000000-0000-0000-0000-000000000000"

iam_rbac_role            = "Reader"
iam_rbac_member_id       = ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000"]
iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
group_rbac_change_record = "CHG"

nsg_map_pe = {
  200 = {
    name                    = "AllowHTTP"
    priority                = "200"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "80"
    source_address_prefixes = ["10.201.124.0/24"]
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
  220 = {
    name                    = "AllowSQL"
    priority                = "220"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "1433"
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
    source_address_prefixes = ["10.201.124.0/24"]
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
