# Environment variables, automatically included

subscription_id = ""
environment_tag = "Dev"
project_tag     = "project02"
app_name        = "project02 Dev"
project_code    = "P02"

b2c_users = {
  "chris" = {
    upn          = "cadmin"
    display_name = "Chris (Local Admin)"
    mail         = "chris@example.tld"
  }
  "rod" = {
    upn          = "radmin"
    display_name = "Rod (Local Admin)"
    mail         = "rod@example.tld"
  }
  "michiel" = {
    upn          = "madmin"
    display_name = "Michiel (Local Admin)"
    mail         = "michiel@example.tld"
  }
  "dimitri" = {
    upn          = "dadmin"
    display_name = "Dimitri (Local Admin)"
    mail         = "dimitri@example.tld"
  }
}

# B2C Group Name
aad_group_name = "Az-AZURE-PERM-Local Admin Roles"

plan_sku_name = "P1v2"
os_plan_type  = "Linux"

vnet_subnet  = "10.200.9.0/25"
snet_subnets = ["10.200.9.0/27", "10.200.9.32/27", "10.200.9.64/27", "10.200.9.96/27"]

iam_rbac_role            = "Reader"
iam_rbac_member          = ""
iam_rbac_member_id       = ["", "", ""]
iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
group_rbac_change_record = ""

mysql_admin    = "<user>"
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

nsg_map_appgw = {
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
