# Local generated values from static variables

locals {
  env = var.environment[var.environment_tag]

  resource_template = "-${var.project_tag}-${local.env}-${var.country_tag}-"

  safe_basename = replace(local.resource_template, "-", "")

  rg_name     = "rg${local.resource_template}001"
  rg_location = var.region

  vnet_name          = "vnet${local.resource_template}001"
  vnet_snet_name     = ["snet${local.resource_template}001", "snet${local.resource_template}002", "snet${local.resource_template}003"]
  vnet_snet_nsg_name = ["nsg-snet${local.resource_template}001", "nsg-snet${local.resource_template}002", "nsg-snet${local.resource_template}003"]

  vnet_snet  = ["10.200.8.0/26"]
  vnet_snets = ["10.200.8.0/28", "10.200.8.16/28", "10.200.8.32/28"]

  asg_be_name = "asg${local.resource_template}002"
  asg_fe_name = "asg${local.resource_template}001"

  mssql_name = "azus-sql${local.resource_template}001"

  app_serplan_name = "sp${local.resource_template}001"

  sql_priv_name     = "pe-sql${local.resource_template}001"
  sql_priv_ser_name = "psc-sql${local.resource_template}001"

  sa_privlink_name  = "pe-sa${local.resource_template}001"
  sa_psc_name       = "psc-sa${local.resource_template}001"
  sa_name           = "sa${local.safe_basename}001"
  sa_container_name = ["sac${local.safe_basename}001", "sac${local.safe_basename}002"]

  app_name = "app${local.resource_template}001"

  appservice_pe_name  = "pe-app${local.resource_template}001"
  appservice_psc_name = "psc-app${local.resource_template}001"

  appserviceslot1_name = "ds${local.resource_template}001"
  appserviceslot2_name = "ds${local.resource_template}002"

  appins_name = "appinsights${local.resource_template}001"

  slots_pe_name = ["pe-ds${local.resource_template}001", "pe-ds${local.resource_template}002"]
  ds_psc_name   = ["psc-ds${local.resource_template}001", "psc-ds${local.resource_template}002"]

  subnets_by_name = tomap({
    for sn in azurerm_subnet.us : sn.name => sn
  })

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
