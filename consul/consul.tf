resource "helm_release" "consul_primary" {
  provider = helm.gcp

  name       = "consul"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "consul"

  values = [
    templatefile("helm/consul.yaml.tmpl", {
      datacenter_name         = "gcp"
      consul_is_primary_dc    = true
      primary_datacenter_name = null
      k8s_host                = null
    })
  ]
}

# DO NOT DO THIS IN A REAL WORLD SCENARIO
resource "kubernetes_secret" "consul_federation" {
  provider = kubernetes.azure

  metadata {
    name = "consul-federation"
  }

  data = {
    caCert              = data.kubernetes_secret.consul_federation.data.caCert
    caKey               = data.kubernetes_secret.consul_federation.data.caKey
    gossipEncryptionKey = data.kubernetes_secret.consul_federation.data.gossipEncryptionKey
    replicationToken    = data.kubernetes_secret.consul_federation.data.replicationToken
    serverConfigJSON    = data.kubernetes_secret.consul_federation.data.serverConfigJSON
  }
}

resource "helm_release" "consul_secondary" {
  depends_on = [
    kubernetes_secret.consul_federation
  ]
  provider = helm.azure

  name       = "consul"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "consul"

  values = [
    templatefile("helm/consul.yaml.tmpl", {
      datacenter_name         = "azure"
      consul_is_primary_dc    = false
      primary_datacenter_name = "gcp"
      k8s_host                = data.azurerm_kubernetes_cluster.credentials.fqdn
    })
  ]
}