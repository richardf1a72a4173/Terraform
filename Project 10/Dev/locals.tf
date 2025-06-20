locals {
  sub_id = "00000000-0000-0000-0000-000000000000" #Dev-Test

  suffix = "project10-d-us"

  rg_location = "eastus2"
  rg_name     = "rg-${local.suffix}-001"

  vnet_name          = "vnet-${local.suffix}-001"
  vnet_snet_name     = "snet-${local.suffix}-001"
  vnet_snet_nsg_name = "nsg-snet-${local.suffix}-001"

  vnet_snet  = ["10.200.7.64/27"]
  vnet_snets = ["10.200.7.64/27"]

  asg_be_name = "asg-${local.suffix}-002"
  asg_fe_name = "asg-${local.suffix}-001"

  mssql_name = "azus-sql-${local.suffix}-001"
  sqldb_name = "sql-${local.suffix}-001"

  sql_priv_name     = "pe-sql-${local.suffix}-001"
  sql_priv_ser_name = "psc-sql-${local.suffix}-001"
  # sql_dns_name       = "pdns-sql-${local.suffix}-001"
  sql_vnet_link_name = "pl-sql-${local.suffix}-001"

  # private_resolver_name         = "pr-${local.suffix}-001"
  # private_resolver_inbound_name = "pr-inbound-${local.suffix}-001"

  tags = {
    "Active Directory" = "n/a"
    "Application Name" = "project10 - Dev"
    Confidentiality    = "n/a"
    "Cost Centre"      = "Project 10"
    Environment        = "Dev"
    "Operations Team"  = "Azure Engineering"
    Project            = "619"
    Region             = "East US 2"
    "Service Hours"    = "n/a"
    "Service Level"    = "n/a"
    Tooling            = "Terraform"
  }
}
