# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Prod"
project_tag     = "project10"
app_name        = "project10"
project_code    = "10"
vnet_snet       = ["10.200.7.160/27"]
vnet_snets      = ["10.200.7.160/27"]

dblogin_username = "user@example.tld"
dbobject_id      = "00000000-0000-0000-0000-000000000000"

iam_rbac_member_id   = ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000"]
iam_rbac_role        = "Reader"
iam_rbac_group_owner = "00000000-0000-0000-0000-000000000000"

group_rbac_change_record = "CHG"

nsg_map = {
  200 = {
    name                    = "SQLInbound"
    priority                = "200"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "1433-1434"
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
