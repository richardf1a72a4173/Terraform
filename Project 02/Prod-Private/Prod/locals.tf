# Local generated values from static variables

locals {
  env = var.environment[var.environment_tag]

  resource_template = "-${var.project_tag}-${local.env}-s-${var.country_tag}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_location = var.region

  targets_resource_id = [
    azurerm_linux_web_app.app.id,
    azurerm_linux_web_app_slot.staging.id,
    azurerm_application_gateway.ag.id,
    azurerm_key_vault.kv.id,
    azurerm_storage_account.storage.id,
    azurerm_public_ip.pip.id,
    azurerm_service_plan.plan.id
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
