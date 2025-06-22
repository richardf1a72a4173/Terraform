resource "azurerm_container_group" "container" {
  name                = "cg${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  restart_policy      = "Always"
  subnet_ids          = [azurerm_subnet.subnet.id]

  container {
    name   = "container${local.resource_template}001"
    image  = "alpinelinux/ansible"
    cpu    = "2"
    memory = "4"

    ports {
      port     = 22
      protocol = "TCP"
    }

    environment_variables = {
      ARM_SUBSCRIPTION_ID = "00000000-0000-0000-0000-000000000000"
      ARM_TENANT_ID       = data.azurerm_client_config.current.tenant_id
      ARM_CLIENT_ID       = "00000000-0000-0000-0000-000000000000"
      TERRAFORM_PROJECT   = "Project 02"
      PROJECT_PATH        = "Project 02/Prod/"
    }

    secure_environment_variables = {
      ARM_CLIENT_SECRET = var.arm_client_secret
    }

    volume {
      name       = "data"
      mount_path = "/data/"
      git_repo {
        url = "https://<user>.:${var.git_repo_pass}@dev.azure.com/<repo>/_git/RF"
      }
    }

    commands = [
      "ansible-playbook /data/Ansible/bootstrap.yaml",
      "ansible-playbook /data/Ansible/terraform_check_plan.yaml"
    ]
  }

  # image_registry_credential {
  #   username = "<user>"
  #   password = var.docker_registry_password
  #   server   = "docker.io"
  # }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}
