<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_group.group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_change_number"></a> [change\_number](#input\_change\_number) | Change Record for Group | `string` | n/a | yes |
| <a name="input_group_description"></a> [group\_description](#input\_group\_description) | Description tag for Group | `string` | n/a | yes |
| <a name="input_group_members"></a> [group\_members](#input\_group\_members) | List of Group Member IDs | `set(string)` | n/a | yes |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Name of Group - AZ-AZURE-{xxx} | `string` | n/a | yes |
| <a name="input_group_owner"></a> [group\_owner](#input\_group\_owner) | Owner Object ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | n/a |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | n/a |
<!-- END_TF_DOCS -->