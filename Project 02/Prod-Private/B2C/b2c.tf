# You cant create a B2C tenant with a SPN, 
# so you would need to terraform plan -target="azurerm_aadb2c_directory.b2c"
# manually as a user with permissions in the RG

resource "azurerm_aadb2c_directory" "b2c" {
  country_code            = "US"
  data_residency_location = "United States"
  display_name            = local.b2c_display_name
  domain_name             = local.b2c_domain_name
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "PremiumP1"

  timeouts {
    create = "60m"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
