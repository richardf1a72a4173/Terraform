# Environment variables, automatically included

subscription_id = "00000000-0000-0000-0000-000000000000"
environment_tag = "Prod"
project_tag     = "project02"
app_name        = "project02 Dev"
project_code    = "P02"

confidentiality = "Highly Confidential"
country_tag     = "eu"
region          = "westeurope"

b2c_masq_domain = "login.project02.com"

b2c_users = {
  "chris" = {
    upn          = "cadmin"
    display_name = "Chris (Local Admin)"
    mail         = "chris@example.tld"
  }
  "rod" = {
    upn          = "radmin"
    display_name = "Rod (Local Admin)"
    mail         = "rod@example.tld"
  }
  "michiel" = {
    upn          = "madmin"
    display_name = "Michiel (Local Admin)"
    mail         = "michiel@example.tld"
  }
  "dimitri" = {
    upn          = "dadmin"
    display_name = "Dimitri (Local Admin)"
    mail         = "dimitri@example.tld"
  }
}

# iam_rbac_role = "Reader"
# iam_rbac_member_id       = ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000"]
# iam_rbac_group_owner     = "00000000-0000-0000-0000-000000000000"
# group_rbac_change_record = "CHG"
