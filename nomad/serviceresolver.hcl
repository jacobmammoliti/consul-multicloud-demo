Kind = "service-resolver"
Name = "facts-api-backend"

ConnectTimeout = "5s"

Failover = {
  "*" = {
    Datacenters = ["aws-west"]
  }
}