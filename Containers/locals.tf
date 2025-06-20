# Local generated values from static variables

locals {
  env = var.environment["${var.environment_tag}"]

  # state_key = "${var.project_tag}${local.env}001.tfstate"

  resource_template = "-${var.project_tag}-${local.env}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_name = "rg${local.resource_template}001"

  rg_location = var.region

  vnet_name    = "vnet${local.resource_template}001"
  vnet_address = ["172.31.201.0/24"]
  snet_name    = "snet${local.resource_template}001"
  snet_address = ["172.31.201.0/24"]

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
}