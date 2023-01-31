output "connection_string" {
  value = format("gcloud container clusters get-credentials %s --zone %s --project %s", var.gke_cluster_name, var.zone, var.project_id)
}