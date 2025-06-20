# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Prod"
project_tag     = "project03"
app_name        = "project03"
project_code    = "03"

vnet_subnet  = "10.200.10.0/25"
snet_subnets = ["10.200.10.0/27", "10.200.10.32/27", "10.200.10.64/27"]
vnet_change  = "CHG"

sql_login_username  = "matt@example.tld"
sql_login_object_id = "00000000-0000-0000-0000-000000000000"

group_rbac_change_record = "CHG"
iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
iam_rbac_member_id = [
  "00000000-0000-0000-0000-000000000000",
  "00000000-0000-0000-0000-000000000000"
]
iam_rbac_role = "Reader"

prod_domain = "project03.<domain>.com"

dev_ip = ""
