locals {
  sub_id = "00000000-0000-0000-0000-000000000000" #Dev-Test

  suffix = "project03-d-us"

  rg_location = "eastus2"
  rg_name     = "rg-${local.suffix}-001"

  cont_prin_id = "00000000-0000-0000-0000-000000000000"

  vnet_name          = "vnet-${local.suffix}-001"
  vnet_snet_name     = ["snet-${local.suffix}-001", "snet-${local.suffix}-002"]
  vnet_snet_nsg_name = ["nsg-snet-${local.suffix}-001", "nsg-snet-${local.suffix}-002"]

  vnet_snet  = ["10.200.7.0/27"]
  vnet_snets = ["10.200.7.0/28", "10.200.7.16/28"]

  asg_be_name = "asg-${local.suffix}-002"
  asg_fe_name = "asg-${local.suffix}-001"

  mssql_name = "azus-sql-${local.suffix}-001"
  sqldb_name = "sql-${local.suffix}-001"

  app_serplan_name = "sp-${local.suffix}-001"

  sql_priv_name      = "pe-sql-${local.suffix}-001"
  sql_priv_ser_name  = "psc-sql-${local.suffix}-001"
  sql_dns_name       = "pdns-sql-${local.suffix}-001"
  sql_vnet_link_name = "pl-sql-${local.suffix}-001"

  sa_privatedns_name = "pl-sa-${local.suffix}-001"
  sa_privlink_name   = "pe-sa-${local.suffix}-001"
  sa_psc_name        = "psc-sa-${local.suffix}-001"
  sa_dnsz_name       = "pdnsz-sa-${local.suffix}-001"
  sa_name            = "saproject03us001"

  app_name = "app-${local.suffix}-001"

  fa_pdns_nl_name     = "pl-app-${local.suffix}-001"
  fa_dnsz_name        = "pdnsz-app-${local.suffix}-001"
  appservice_pe_name  = "pe-app-${local.suffix}-001"
  appservice_psc_name = "psc-app-${local.suffix}-001"

  subnets_by_name = tomap({
    for sn in azurerm_subnet.us : sn.name => sn
  })

  private_resolver_name = "pr-${local.suffix}-001"

  tags = {
    "Active Directory" = "n/a"
    "Application Name" = "project03 - Dev"
    Confidentiality    = "n/a"
    "Cost Centre"      = "Project 03"
    Environment        = "Dev"
    "Operations Team"  = "Azure Engineering"
    Project            = "619"
    Region             = "East US 2"
    "Service Hours"    = "n/a"
    "Service Level"    = "n/a"
    Tooling            = "Terraform"
  }
}
