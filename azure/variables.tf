variable "resource_group_name" {
  description = "(Required) The name of Resource Group to deploy to."
  type        = string
}

variable "tags" {
  description = "(Optional) A map of tags to assign to infrastructure deployed."
  type        = map(string)
  default = {
    "event" = "hashitalks2023"
  }
}

variable "aks_cluster_name" {
  description = "(Optional) The name of the AKS cluster."
  type        = string
  default     = "tooling-cluster"
}

variable "aks_node_pool_count" {
  description = "(Optional) The number of nodes to create in each AKS node pool."
  type        = number
  default     = 3
}

variable "aks_node_pool_machine_type" {
  description = "(Optional) The machine type to use for each node in each AKS node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_disk_size_gb" {
  description = "(Optional) The size of the disk to attach to each node in each AKS node pool."
  type        = number
  default     = 50
}

variable "aks_version" {
  description = "(Optional) The version the AKS worker nodes will be."
  type        = string
  default     = "1.23"
}

variable "consul_is_primary_dc" {
  description = "(Optional) Flags the Consul datacenter as primary. This will generate a replication token, gossip encryption key, and federation secret."
  type        = bool
  default     = false
}