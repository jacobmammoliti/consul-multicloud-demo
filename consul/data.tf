data "google_client_config" "current" {}

data "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.gke_location
  project  = var.gcp_project_id
}

data "azurerm_kubernetes_cluster" "credentials" {
  name                = var.aks_cluster_name
  resource_group_name = var.azure_resource_group_name
}

# DO NOT DO THIS IN A REAL WORLD SCENARIO
# This is will cause Terraform to store the secrets data
# in plaintext in the state file.

data "kubernetes_secret" "consul_federation" {
  depends_on = [
    helm_release.consul_primary
  ]
  provider = kubernetes.gcp

  metadata {
    name = "consul-federation"
  }
}