module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix  = [var.project_tag, local.env, "s", var.country_tag]
}
