# Local generated values from static variables

locals {
  env = var.environment[var.environment_tag]

  resource_template = "-${var.project_tag}-${local.env}-${var.country_tag}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_name     = "rg${local.resource_template}001"
  rg_location = var.region

  group_name        = "PERM-${local.rg_name} - ${var.iam_rbac_role}"
  group_description = "Group providing access to ${local.rg_name} - ${var.iam_rbac_role}"

  vnet_name          = "vnet${local.resource_template}001"
  vnet_snet_name     = "snet${local.resource_template}001"
  vnet_snet_nsg_name = "nsg-snet${local.resource_template}001"

  mssql_name = "azus-sql${local.resource_template}001"
  sqldb_name = "sql${local.resource_template}001"

  sql_priv_name     = "pe-sql${local.resource_template}001"
  sql_priv_ser_name = "psc-sql${local.resource_template}001"

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
