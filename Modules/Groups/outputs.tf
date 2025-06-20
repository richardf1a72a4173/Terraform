output "group_name" {
  value = azuread_group.group.display_name
}

output "group_id" {
  value = azuread_group.group.id
}
