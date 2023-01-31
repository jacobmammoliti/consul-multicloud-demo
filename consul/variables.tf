variable "gcp_project_id" {
  description = "(Required) The ID of the GCP Project to deploy into."
  type        = string
}

variable "gke_cluster_name" {
  description = "(Required) The name of the GKE cluster to deploy Consul to."
  type        = string
}

variable "gke_location" {
  description = "(Required) The location the GKE cluster is deployed in."
  type        = string
}

variable "azure_resource_group_name" {
  description = "(Required) The name of Azure Resource Group to deploy to."
  type        = string
}

variable "aks_cluster_name" {
  description = "(Required) The name of the AKS cluster to deploy Consul to."
  type        = string
}