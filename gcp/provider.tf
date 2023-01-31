terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.48.0"
    }
  }
}

provider "google" {}

provider "helm" {
  kubernetes {
    host     = format("https://%s", module.tooling_cluster.endpoint)
    token    = data.google_client_config.default.access_token
    insecure = true # Running into a "x509: Signed by unknown CA" in lab
    # cluster_ca_certificate = base64decode(module.tooling-cluster.ca_certificate)
  }
}