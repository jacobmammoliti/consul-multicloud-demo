variable "project_id" {
  description = "(Required) The ID of the GCP Project to deploy into."
  type        = string
}

variable "region" {
  description = "(Optional) The GCP region to deploy to."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "(Optional) The GCP zone to deploy to."
  type        = string
  default     = "us-central1-a"
}

variable "vpc_network_name" {
  description = "(Optional) The name of the VPC network to use."
  type        = string
  default     = "default"
}

variable "vpc_subnet_name" {
  description = "(Optional) The name of the VPC subnetwork to use."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "(Optional) A map of labels to assign to infrastructure deployed."
  type        = map(string)
  default = {
    "event" = "hashitalks2023"
  }
}

variable "gke_cluster_name" {
  description = "(Optional) The name of the GKE cluster."
  type        = string
  default     = "tooling-cluster"
}

variable "gke_node_pool_count" {
  description = "(Optional) The number of nodes to create in each GKE node pool."
  type        = number
  default     = 3
}

variable "gke_node_pool_machine_type" {
  description = "(Optional) The machine type to use for each node in each GKE node pool."
  type        = string
  default     = "e2-small"
}

variable "gke_disk_size_gb" {
  description = "(Optional) The size of the disk to attach to each node in each GKE node pool."
  type        = number
  default     = 50
}

variable "gke_version" {
  description = "(Optional) The version the GKE worker nodes will be."
  type        = string
  default     = "1.23.14-gke.1800"
}

variable "consul_is_primary_dc" {
  description = "(Optional) Flags the Consul datacenter as primary. This will generate a replication token, gossip encryption key, and federation secret."
  type        = bool
  default     = false
}