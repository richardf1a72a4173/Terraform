resource "azurerm_user_assigned_identity" "identity" {
  location            = azurerm_resource_group.this.location
  name                = "aks-identity"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_container_registry" "myacr" {
  name                = module.naming.container_registry.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Standard"
  admin_enabled       = true
}

module "avm-res-containerservice-managedcluster" {
  source           = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version          = "0.1.9"
  enable_telemetry = false

  name                       = module.naming.kubernetes_cluster.name_unique
  resource_group_name        = azurerm_resource_group.this.name
  node_resource_group_name   = "${azurerm_resource_group.this.name}-node"
  location                   = azurerm_resource_group.this.location
  sku_tier                   = "Standard"
  private_cluster_enabled    = true
  private_dns_zone_id        = azurerm_private_dns_zone.zone.id
  dns_prefix_private_cluster = random_string.dns_prefix.result
  run_command_enabled        = true

  azure_active_directory_role_based_access_control = {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  managed_identities = {
    system_assigned            = false
    user_assigned_resource_ids = [azurerm_user_assigned_identity.identity.id]
  }

  role_assignments = {
    "me" = {
      role_definition_id_or_name = "Owner"
      principal_id               = data.azurerm_client_config.current.object_id
    }
    "kubespn" = {
      role_definition_id_or_name = "Owner"
      principal_id               = azurerm_linux_virtual_machine.mgmt.identity[0].principal_id
    }
  }

  # network_profile = {
  #   dns_service_ip = "10.10.200.10"
  #   service_cidr   = "10.10.200.0/24"
  #   network_plugin = "azure"
  # }

  default_node_pool = {
    name                         = "default"
    vm_size                      = "Standard_DS2_v2"
    auto_scaling_enabled         = true
    max_count                    = 3
    max_pods                     = 30
    min_count                    = 1
    vnet_subnet_id               = azurerm_subnet.subnet.id
    only_critical_addons_enabled = true

    upgrade_settings = {
      max_surge = "10%"
    }
  }

  node_pools = {
    unp1 = {
      name                 = "userpool1"
      vm_size              = "Standard_DS2_v2"
      auto_scaling_enabled = true
      max_count            = 3
      max_pods             = 30
      min_count            = 1
      os_disk_size_gb      = 128
      vnet_subnet_id       = azurerm_subnet.unp1_subnet.id

      upgrade_settings = {
        max_surge = "10%"
      }
    }
    #     unp2 = {
    #       name                 = "userpool2"
    #       vm_size              = "Standard_DS2_v2"
    #       auto_scaling_enabled = true
    #       max_count            = 3
    #       max_pods             = 30
    #       min_count            = 1
    #       os_disk_size_gb      = 128
    #       vnet_subnet_id       = azurerm_subnet.unp2_subnet.id

    #       upgrade_settings = {
    #         max_surge = "10%"
    #       }
    #     }
  }
}
