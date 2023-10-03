job "facts-api-backend" {
  datacenters = ["gcp-east"]

  group "facts-api-backend" {
    network {
      mode = "bridge"
    }
    
    service {
      name     = "facts-api-backend"
      port     = "3000"
      provider = "consul"

      connect {
        sidecar_service {}
      }
    }
    
    task "facts-api-backend" {
      driver = "docker"

      config {
        image = "jacobmammoliti/facts-api-backend:latest"
      }
    }
  }
}