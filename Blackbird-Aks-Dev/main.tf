resource "azurerm_resource_group" "this" {
 name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

//Azure virtual network
resource "azurerm_virtual_network" "this" {
  name                = "${var.vnet_name}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags
}

#module "subnets" {
 # source                    = "./modules/subnets"
  #resource_group_name       = var.resource_group_name
  #virtual_network_name      = azurerm_virtual_network.this.name
  #network_security_group_id = azurerm_network_security_group.this.id
  #location                  = var.location
  #subnets = [{
    #name              = var.subnet_names
    #address_prefix    = var.subnet_prefixes
    #service_endpoints = var.subnet_service_endpoints
 # }]
#}
  
resource "azurerm_network_security_group" "this" {
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

//AKS

resource "azurerm_kubernetes_cluster" "main" {
  name                    = var.cluster_name == null ? "${var.prefix}-aks" : var.cluster_name
  kubernetes_version      = var.kubernetes_version
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  dns_prefix              = var.prefix
  sku_tier                = var.sku_tier
  private_cluster_enabled = var.private_cluster_enabled

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]
    content {
      orchestrator_version  = var.orchestrator_version
      name                  = var.agents_pool_name
      node_count            = var.agents_count
      vm_size               = var.agents_size
      os_disk_size_gb       = var.os_disk_size_gb
      vnet_subnet_id        = var.vnet_subnet_id
      enable_auto_scaling   = var.enable_auto_scaling
      max_count             = null
      min_count             = null
      enable_node_public_ip = var.enable_node_public_ip
      availability_zones    = var.agents_availability_zones
      node_labels           = var.agents_labels
      type                  = var.agents_type
      tags                  = merge(var.tags, var.agents_tags)
      max_pods              = var.agents_max_pods
      //TODO - fix or remove
      #enable_host_encryption = var.enable_host_encryption
    }
  }

  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []
    content {
      orchestrator_version  = var.orchestrator_version
      name                  = var.agents_pool_name
      vm_size               = var.agents_size
      os_disk_size_gb       = var.os_disk_size_gb
      vnet_subnet_id        = var.vnet_subnet_id
      enable_auto_scaling   = var.enable_auto_scaling
      max_count             = var.agents_max_count
      min_count             = var.agents_min_count
      enable_node_public_ip = var.enable_node_public_ip
      availability_zones    = var.agents_availability_zones
      node_labels           = var.agents_labels
      type                  = var.agents_type
      tags                  = merge(var.tags, var.agents_tags)
      max_pods              = var.agents_max_pods
      //TODO - fix or remove
      #enable_host_encryption = var.enable_host_encryption
    }
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    kube_dashboard {
      enabled = var.enable_kube_dashboard
    }

    azure_policy {
      enabled = var.enable_azure_policy
    }

    oms_agent {
      enabled                    = var.enable_log_analytics_workspace
      log_analytics_workspace_id = var.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.main[0].id : null
    }
  }

  role_based_access_control {
    enabled = var.enable_role_based_access_control

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed                = true
        admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      }
    }

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && !var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed           = false
        client_app_id     = var.rbac_aad_client_app_id
        server_app_id     = var.rbac_aad_server_app_id
        server_app_secret = var.rbac_aad_server_app_secret
      }
    }
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.net_profile_dns_service_ip
    docker_bridge_cidr = var.net_profile_docker_bridge_cidr
    outbound_type      = var.net_profile_outbound_type
    pod_cidr           = var.net_profile_pod_cidr
    service_cidr       = var.net_profile_service_cidr
  }

  tags = var.tags
}


resource "azurerm_log_analytics_workspace" "main" {
  count               = var.enable_log_analytics_workspace ? 1 : 0
  name                = var.cluster_log_analytics_workspace_name == null ? "${var.prefix}-workspace" : var.cluster_log_analytics_workspace_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
  count                 = var.enable_log_analytics_workspace ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  workspace_resource_id = azurerm_log_analytics_workspace.main[0].id
  workspace_name        = azurerm_log_analytics_workspace.main[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

resource "azurerm_container_registry" "acr" {
  name     = var.acr_name
  resource_group_name      = "AZ-AS-RGP-EX-N-SEQ01414-DEV"
  location                 = "West Europe"
  sku                      = "standard"
  admin_enabled            = false
}
