output "connection_string" {
  value = format("az aks get-credentials --resource-group %s --name %s", var.resource_group_name, var.aks_cluster_name)
}