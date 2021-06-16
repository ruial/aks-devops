resource "azuredevops_project" "aks_automation" {
  name         = "aks-automation"
  description  = "Kubernetes automation demo"
}

resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.aks_automation.id
  name       = "aks-devops"
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_serviceendpoint_dockerregistry" "aks_registry" {
  project_id             = azuredevops_project.aks_automation.id
  service_endpoint_name  = "Azure Container Registry"

  docker_registry        = azurerm_container_registry.aks_registry.login_server
  docker_username        = azurerm_container_registry.aks_registry.admin_username
  docker_password        = azurerm_container_registry.aks_registry.admin_password
  registry_type          = "Others"
}

resource "azuredevops_serviceendpoint_kubernetes" "aks" {
  project_id            = azuredevops_project.aks_automation.id
  service_endpoint_name = "Kubernetes"
  apiserver_url         = "https://${azurerm_kubernetes_cluster.aks_cluster.fqdn}"
  authorization_type    = "Kubeconfig"

  kubeconfig {
    kube_config            = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
    cluster_context        = azurerm_kubernetes_cluster.aks_cluster.name
  }
}
