output "aks_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

output "acr_name" {
  value = azurerm_container_registry.aks_registry.name
}

output "ado_acr_id" {
  value = azuredevops_serviceendpoint_dockerregistry.aks_registry.id
}

output "ado_aks_id" {
  value = azuredevops_serviceendpoint_kubernetes.aks.id
}

output "ado_repo_url" {
  value = azuredevops_git_repository.repo.remote_url
}
