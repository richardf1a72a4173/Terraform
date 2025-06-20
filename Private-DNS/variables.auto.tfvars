# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Prod"
project_tag     = "privatedns"
app_name        = "Private DNS Resolver"
#project_code = ""

region2-vnet  = ["10.201.250.0/26"]
region2-snets = ["10.201.250.0/27", "10.201.250.32/27"]

nsg_map_eu_ie = {
  4000 = {
    name                    = "DenyInbound"
    priority                = "4000"
    direction               = "Inbound"
    access                  = "Deny"
    protocol                = "*"
    destination_port_range  = "*"
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }
  200 = {
    name                    = "DNSAllow"
    priority                = "200"
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    destination_port_range  = "53"
    source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  }
}
