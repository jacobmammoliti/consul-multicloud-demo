module "aks" {
  source  = "Azure/aks/azurerm"
  version = "6.5.0"

  prefix                = "hashitalks2023"
  cluster_name          = var.aks_cluster_name
  kubernetes_version    = var.aks_version
  location              = data.azurerm_resource_group.default_resource_group.location
  os_disk_size_gb       = var.aks_disk_size_gb
  tags                  = var.tags
  agents_count          = var.aks_node_pool_count
  resource_group_name   = var.resource_group_name
  agents_size           = var.aks_node_pool_machine_type
  enable_node_public_ip = true
}