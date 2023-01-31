terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.48.0"
    }
  }
}

provider "google" {}

provider "azurerm" {
  features {}
}

provider "helm" {
  alias = "gcp"
  kubernetes {
    host     = format("https://%s", data.google_container_cluster.primary.endpoint)
    token    = data.google_client_config.current.access_token
    insecure = true # Running into a "x509: Signed by unknown CA" in our lab
    # cluster_ca_certificate = base64decode(module.tooling-cluster.ca_certificate)
  }
}

provider "kubernetes" {
  alias = "gcp"

  host     = format("https://%s", data.google_container_cluster.primary.endpoint)
  token    = data.google_client_config.current.access_token
  insecure = true # Running into a "x509: Signed by unknown CA" in our lab  
}

provider "helm" {
  alias = "azure"
  kubernetes {
    host               = data.azurerm_kubernetes_cluster.credentials.fqdn
    client_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key         = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    insecure           = true # Running into a "x509: Signed by unknown CA" in our lab
    # cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  alias = "azure"

  host               = format("https://%s", data.azurerm_kubernetes_cluster.credentials.fqdn)
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
  client_key         = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
  insecure           = true # Running into a "x509: Signed by unknown CA" in our lab
}