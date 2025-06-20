# Local generated values from static variables

locals {
  env = var.environment[var.environment_tag]

  resource_template = "-${var.project_tag}-${local.env}-s-${var.country_tag}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_name     = "rg${local.resource_template}002"
  rg_location = var.region

  b2c_display_name = "B2C${local.resource_template}001"
  b2c_domain_name  = "b2c${local.safe_basename}001.onmicrosoft.com"


  tags = {
    "Environment"      = var.environment_tag
    "Active Directory" = var.ad
    "Application Name" = var.app_name
    "Confidentiality"  = var.confidentiality
    "Cost Centre"      = var.cost_centre
    "Operations Team"  = var.ops_team
    "Project"          = var.project_code
    "Region"           = var.region
    "Service Hours"    = var.service_hours
    "Service Level"    = var.service_level
    "Tooling"          = "Terraform"
    "Deploy Date"      = time_static.time.rfc3339
  }
}
