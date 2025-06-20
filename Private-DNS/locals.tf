# Local generated values from static variables

locals {
  env = var.environment["${var.environment_tag}"]

  resource_template  = "-${var.project_tag}-${local.env}-${var.country_tag}-"
  resource_template2 = "-${var.project_tag}-${local.env}-${var.country_tag2}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_name     = "rg${local.resource_template}001"
  rg_location = var.region

  vnet2_name   = "vnet${local.resource_template2}001"
  snets2_names = ["snet${local.resource_template2}001", "snet${local.resource_template}002"]
  nsg2_names   = ["nsg-snet${local.resource_template2}001", "nsg-snet${local.resource_template2}002"]

  eu_privdns_name = "pr${local.resource_template2}001"
  eu_oe_name      = "oe${local.resource_template2}001"
  eu_ie_name      = "ie${local.resource_template2}001"
  eu_ruleset_name = "prr${local.resource_template2}001"

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