job "facts-api-frontend" {
  datacenters = ["gcp-east"]

  group "facts-api-frontend" {
    network {
      mode = "bridge"

      port "http" {
        static = 8000
        to     = 8000
      }
    }
    
    service {
      name     = "facts-api-frontend"
      port     = "8000"
      provider = "consul"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "facts-api-backend"
              local_bind_port  = 3000
            }
          }
        }
      }
    }
    
    task "facts-api-frontend" {
      driver = "docker"

      config {
        image = "jacobmammoliti/facts-api-frontend:latest"
      }

      env {
        CLOUD = "GCP"
      }
    }
  }
}