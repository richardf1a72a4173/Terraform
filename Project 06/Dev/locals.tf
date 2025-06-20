# Local generated values from static variables

locals {
  env = var.environment["${var.environment_tag}"]

  resource_template = "-${var.project_tag}-${local.env}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_name = "rg${local.resource_template}001"

  rg_location = var.region

  group_name        = "PERM${local.resource_template}001 ${var.iam_rbac_role}"
  group_description = "Group providing access to ${local.rg_name} - ${var.iam_rbac_role}"

  synapse_workspace_name = "syn${local.resource_template}001"

  storage_account_name = "sa${local.safe_basename}001"

  storage_dlfs_name = "sdlfs${local.resource_template}001"

  syn_spark_pool_name = "synsp001"

  mssql_name   = "sql${local.resource_template}001"
  mssql_dbname = "sql-db-synapse${local.resource_template}001"

  db_username   = var.iam_rbac_member
  db_user_objid = var.iam_rbac_member_id

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