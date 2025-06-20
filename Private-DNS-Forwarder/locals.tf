# Local generated values from static variables

locals {
  env = var.environment["${var.environment_tag}"]

  resource_template = "-${var.project_tag}-${local.env}-${var.country_tag}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_location = var.region

  vnet_snet  = ["10.200.250.64/26"]
  vnet_snet1 = ["10.200.250.64/27"]
  vnet_snet2 = ["10.200.250.96/27"]

  tags = {
    "Environment"      = "${var.environment_tag}"
    "Active Directory" = "${var.ad}"
    "Application Name" = "${var.app_name}"
    "Confidentiality"  = "${var.confidentiality}"
    "Cost Centre"      = "${var.cost_centre}"
    "Operations Team"  = "${var.ops_team}"
    "Project"          = "${var.project_code}"
    "Region"           = "${var.region}"
    "Service Hours"    = "${var.service_hours}"
    "Service Level"    = "${var.service_level}"
    "Tooling"          = "Terraform"
    "Deploy Date"      = "${time_static.time.rfc3339}"
  }

  nsg_map_app = {
    200 = {
      name                    = "AllowDNS"
      priority                = "200"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "*"
      destination_port_range  = "53"
      source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    }
    210 = {
      name                    = "AllowAdmin"
      priority                = "210"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "*"
      destination_port_range  = "80"
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

  nsg_map_db = {
    200 = {
      name                    = "AllowSQL"
      priority                = "200"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "*"
      destination_port_range  = "3306"
      source_address_prefixes = local.vnet_snet1
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
}
