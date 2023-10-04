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
              datacenter       = "gcp-east"
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
        CLOUD        = "GCP"
        API_ENDPOINT = "${NOMAD_UPSTREAM_IP_facts_api_backend}"
        API_PORT     = "${NOMAD_UPSTREAM_PORT_facts_api_backend}"
      }
    }
  }
}