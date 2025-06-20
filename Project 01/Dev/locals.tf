locals {
  sub_id = "00000000-0000-0000-0000-000000000000"

  suffix = "emission-d"

  rg_location = "eastus2"
  rg_name     = "rg-${local.suffix}-001"

  cont_prin_id = "00000000-0000-0000-0000-000000000000"

  mssql_name         = "azus-sql-${local.suffix}-001"
  mssql_dbname       = ["sql-${local.suffix}-001", "sql-emissionStatic-d-001"]
  sql_vnet_link_name = "pe-sql-${local.suffix}-001"

  sa_name = "saemissiond"

  sa_by_name = tomap({
    for sa in azurerm_storage_account.sa : sa.name => sa
  })

  asp_name       = "asp-${local.suffix}-001"
  vnet_name      = "vnet-${local.suffix}-001"
  vnet_snet_name = ["snet-${local.suffix}-001", "snet-${local.suffix}-002", "snet-${local.suffix}-003"]
  vnet_snet      = ["10.200.96.128/25"]
  vnet_snets     = ["10.200.96.128/27", "10.200.96.160/27", "10.200.96.192/27"]

  subnets_by_name = tomap({
    for sn in azurerm_subnet.rg : sn.name => sn
  })

  vnet_snet_nsg_name = ["nsg-snet-${local.suffix}-001", "nsg-snet-${local.suffix}-002"]

  nsg_by_name = tomap({
    for nsg in azurerm_network_security_group.rg : nsg.name => nsg
  })

  asg_fe_name = "asg-apps-${local.suffix}-001"
  asg_be_name = "asg-sql-${local.suffix}-001"

  sql_db_admin           = "AFDev.Hull@example.tld"
  sql_db_admin_objid     = "00000000-0000-0000-0000-000000000000"
  sql_db_admin_tenant_id = "00000000-0000-0000-0000-000000000000"

  sql_priv_name     = "pe-sql-${local.suffix}-001"
  sql_priv_ser_name = "psc-${local.suffix}-001"
  # sql_dns_name      = "pdns-sql-${local.suffix}-001"
  kv_name           = "kvemissiond001"
  function_app_name = ["fa-emission-finint-d-001", "fa-emission-driftcorr-d-001"]
  app_service_name  = ["as-${local.suffix}-001", "as-emission-api-d-001"]
  app_serplan_name  = ["asp-${local.suffix}-001", "asp-${local.suffix}-002"]

  serplan_by_name = tomap({
    for sp in azurerm_service_plan.rg : sp.name => sp
  })

  kv_privlink_name = "pe-kv-${local.suffix}-001"
  # kv_dns_name            = "pdns-kv-${local.suffix}-001"
  kv_pe_name  = "pe-kv-${local.suffix}-001"
  kv_psc_name = "psc-kv-${local.suffix}-001"
  # fa_pdns_nl_name        = "pdns-fa-${local.suffix}-001"
  fa_pe_name = "pe-fa-${local.suffix}"
  # fa_dnsz_name           = "pdnsz-fa-${local.suffix}-001"
  fa_psc_name = "psc-fa-${local.suffix}-001"
  # sa_privatedns_name     = "pdns-sa-${local.suffix}-001"
  sa_privlink_name = "pe-sa-${local.suffix}"
  sa_psc_name      = "psc-sa-${local.suffix}-001"
  # sa_dnsz_name           = "pdnsz-sa-${local.suffix}-001"
  appservice_pe_name  = ["pe-as-${local.suffix}-001", "pe-as-${local.suffix}-002"]
  appservice_psc_name = ["psc-as-${local.suffix}-001", "psc-as-${local.suffix}-002"]
  # appservice_dns_nl_name = "pdns-as-${local.suffix}-001"

  ag_name = "ag-${local.suffix}-001"

  ua_id_name = "mi-${local.suffix}-001"

  waf_name = "waf-${local.suffix}-001"

  pip_name = "pip-${local.suffix}-001"

  kv_cert_name = "ssl"

  tags = {
    "Active Directory" = "n/a"
    "Application Name" = "Dev"
    Confidentiality    = "n/a"
    "Cost Centre"      = ""
    Environment        = "Dev"
    "Operations Team"  = ""
    Project            = "Project 01"
    Region             = "East US 2"
    "Service Hours"    = "n/a"
    "Service Level"    = "n/a"
    Tooling            = "Terraform"
  }
}
