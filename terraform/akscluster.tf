resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-devops-${lower(join("", regexall("[A-Z]", var.location)))}"
  location = var.location
}

resource "azurerm_dns_zone" "aks_public_zone" {
  name                = var.dns_zone
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_container_registry" "aks_registry" {
  name                     = "${replace(azurerm_resource_group.aks_rg.name, "-", "")}registry"
  resource_group_name      = azurerm_resource_group.aks_rg.name
  location                 = azurerm_resource_group.aks_rg.location
  sku                      = "Standard"
  admin_enabled            = true
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version  = "1.19.11"
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"

  default_node_pool {
    name                 = "systempool"
    vm_size              = "Standard_B2s"
    orchestrator_version = "1.19.11"
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = false
    node_count           = 2
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
    }
    tags = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "aksadmin"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  network_profile {
    network_plugin = "kubenet"
  }

}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.aks_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_zone_contrib" {
  scope                = azurerm_dns_zone.aks_public_zone.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}
