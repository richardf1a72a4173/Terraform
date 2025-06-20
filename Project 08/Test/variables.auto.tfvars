# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Test"
project_tag     = "project08"
app_name        = "project08"
project_code    = "08"

vnet_subnet  = "10.200.11.0/25"
snet_subnets = ["10.200.11.0/27", "10.200.11.32/27", "10.200.11.64/27"]
vnet_change  = "CHG"

iam_rbac_role            = "Reader"
iam_rbac_member_id       = ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000"]
iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
group_rbac_change_record = "CHG"

dev_ips = ["", ""]

api_access_ips = [
  "",
]

sendgrid_api_key = ""

nsg_map_pe = {
  200 = {
    name                    = "AllowHTTP"
    priority                = "200"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "80"
    source_address_prefixes = ["10.200.11.0/25"]
  }
  210 = {
    name                    = "AllowHTTPS"
    priority                = "210"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "443"
    source_address_prefixes = ["10.200.11.0/25"]
  }
  220 = {
    name                    = "AllowAMPQ"
    priority                = "220"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "5671-5672"
    source_address_prefixes = ["10.200.11.0/25"]
  }
}
