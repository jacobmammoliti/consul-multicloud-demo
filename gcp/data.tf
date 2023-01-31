data "google_client_config" "default" {}

data "google_compute_network" "vpc_network" {
  project = var.project_id
  name    = var.vpc_network_name
}

data "google_compute_subnetwork" "vpc_subnetwork" {
  project = var.project_id
  name    = var.vpc_subnet_name
  region  = var.region
}