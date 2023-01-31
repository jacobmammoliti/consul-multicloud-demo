terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.39.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host               = module.aks.host
    client_certificate = base64decode(module.aks.client_certificate)
    client_key         = base64decode(module.aks.client_key)
    insecure           = true # Running into a "x509: Signed by unknown CA" in lab
    # cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}
