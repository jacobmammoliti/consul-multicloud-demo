resource "google_service_account" "gke_service_account" {
  project      = var.project_id
  account_id   = "gke-tooling"
  display_name = "GKE Tooling Service Account"
}

module "tooling_cluster" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-cluster?ref=v19.0.0"
  project_id = var.project_id
  name       = var.gke_cluster_name
  location   = var.zone
  vpc_config = {
    network    = data.google_compute_network.vpc_network.self_link
    subnetwork = data.google_compute_subnetwork.vpc_subnetwork.self_link
    secondary_range_names = {
      pods     = null
      services = null
    }
  }
  release_channel = "UNSPECIFIED"
  labels = var.labels
}

module "tooling_cluster_nodepool_1" {
  source       = "github.com/GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-nodepool?ref=v19.0.0"
  project_id   = var.project_id
  cluster_name = module.tooling_cluster.name
  location     = var.zone
  name         = format("%s-nodepool-1", var.gke_cluster_name)
  node_count = {
    initial = var.gke_node_pool_count
  }
  node_config = {
    disk_size_gb = var.gke_disk_size_gb
    machine_type = var.gke_node_pool_machine_type
  }
  nodepool_config = {
    management = {
      auto_repair = true
      auto_upgrade = false
    }
  }
  gke_version = var.gke_version
  service_account = {
    create = false
    email  = google_service_account.gke_service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}