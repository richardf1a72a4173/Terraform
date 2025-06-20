# Local generated values from static variables

locals {
  env = var.environment[var.environment_tag]

  resource_template = "-${var.project_tag}-${local.env}-s-${var.country_tag}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_name     = "rg${local.resource_template}001"
  rg_location = var.region


  kv_name = "kv${local.resource_template}001"

  mysql_name = "mysql${local.resource_template}001"
  db_name    = "mysql-db${local.resource_template}001"

  app_name   = "app${local.resource_template}001"
  plan_name  = "asp${local.resource_template}001"
  appin_name = "ai${local.resource_template}001"

  ag_name  = "ag${local.resource_template}001"
  waf_name = "waf${local.resource_template}001"

  app_hostname   = var.http_hostname == "" ? "${var.project_tag}-${local.env}-s-${var.country_tag}-001.${data.azurerm_dns_zone.devdns.name}" : var.http_hostname
  app_hostname_2 = var.http_hostname_2 == "" ? "${var.project_tag}-${local.env}-s-${var.country_tag}-002.${data.azurerm_dns_zone.devdns.name}" : var.http_hostname

  ag_mi_name = "mi${local.resource_template}001"

  monitor_name = "mon${local.resource_template}001"
  law_name     = "law${local.resource_template}001"

  group_name        = "PERM-${local.rg_name} - ${var.iam_rbac_role}"
  group_description = "Group providing access to ${local.rg_name} - ${var.iam_rbac_role}"

  vnet_name  = "vnet${local.resource_template}001"
  snet_names = ["snet${local.resource_template}001", "snet${local.resource_template}002", "snet${local.resource_template}003", "snet${local.resource_template}004"]
  nsg_names  = ["nsg-snet${local.resource_template}001", "nsg-snet${local.resource_template}002", "nsg-snet${local.resource_template}003", "nsg-snet${local.resource_template}004"]
  asg_names  = ["asg${local.resource_template}001", "asg${local.resource_template}002", "asg${local.resource_template}003", "asg${local.resource_template}004"]
  sa_name    = "sa${local.safe_basename}001"

  share_name = "share${local.safe_basename}001"
  pip_name   = "pip${local.resource_template}001"
  dns_a_name = ["${var.project_tag}-${local.env}-s-${var.country_tag}-001", "${var.project_tag}-${local.env}-s-${var.country_tag}-002"]


  kv_pe_name  = "pe-kv${local.resource_template}001"
  kv_psc_name = "psc-k${local.resource_template}001"

  sa_privlink_name = "pe-sa${local.resource_template}001"
  sa_psc_name      = "psc-sa${local.resource_template}001"

  appservice_pe_name  = "pe-app${local.resource_template}001"
  appservice_psc_name = "psc-app${local.resource_template}001"

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
