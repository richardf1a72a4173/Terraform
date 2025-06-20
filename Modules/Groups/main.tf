resource "azuread_group" "group" {
  display_name     = local.group_name
  owners           = [var.group_owner]
  security_enabled = true
  description      = "${var.change_number} - ${var.group_description}"

  prevent_duplicate_names = true

  members = var.group_members

  lifecycle {
    prevent_destroy = true
  }
}
