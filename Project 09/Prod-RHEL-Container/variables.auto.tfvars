# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Prod"
project_tag     = "project09"
app_name        = "project09"
project_code    = "P09"

vnet_subnet  = "10.200.187.0/24"
snet_subnets = ["10.200.187.0/27", "10.200.187.32/27", "10.200.187.64/27", "10.200.187.96/27", "10.200.187.128/27"]

iam_rbac_role = "Reader"
# iam_rbac_member          = ""
iam_rbac_member_id       = [""]
iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
group_rbac_change_record = "CHG"

mysql_admin    = "mysql_admin"
mysql_password = "<pass>"

http_hostname = "project09.<domain>.com"

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
