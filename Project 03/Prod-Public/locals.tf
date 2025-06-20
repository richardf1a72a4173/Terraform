# Local generated values from static variables

locals {
  env = var.environment[var.environment_tag]

  resource_template = "-${var.project_tag}-${local.env}-${var.country_tag}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_location = var.region

  targets_resource_id = [
    azurerm_windows_web_app.us.id,
    azurerm_storage_account.us.id,
    azurerm_mssql_server.us.id,
    azurerm_cdn_frontdoor_profile.afd.id
  ]

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
    "VNET"             = var.vnet_change == "" ? var.vnet_subnet : "${var.vnet_change} - ${var.vnet_subnet}"
  }
}
