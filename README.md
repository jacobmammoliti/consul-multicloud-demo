# Consul Multi-cloud WAN Federation Demo
This repository contains Terraform code to deploy a Google Kubernetes Engine (GKE) and Azure Kubernetes Service (AKS) cluster and then deploy HashiCorp Consul on both clusters. Each instance of Consul is deployed with a Mesh Gateway to support WAN federation to join the two clusters.

> **Note:** The Terraform in this repo uses the `kubernetes_secret` resource and data resource which is strongly not recommended in a real world deployment since it will store the secret values in plaintext in state. This is only used in the demo to ease the deployment of the Consul clusters.

## Requirements

### Google Cloud Platform (GCP)
The following are prerequisites in GCP:
  - A project
  - The permissions to create a GKE cluster in that project

### Microsoft Azure
The following are prerequisites in Azure:
  - A resource group
  - The permissions to create an AKS cluster in that resource group

## How to Run
Build each Kubernetes clusters first.

### Google Kubernetes Engine (GKE)
This will deploy a GKE cluster and output the connection string that will build your kubeconfig.
```bash
# in the gcp/ directory

terraform init

terraform plan

terraform apply
```

> output
```
connection_string = "gcloud container clusters get-credentials tooling-cluster --zone us-central1-a --project speedy-league-365514"
```

### Azure Kubernetes Service (AKS)
This will deploy a AKS cluster and output the connection string that will build your kubeconfig.
```bash
# in the azure/ directory

terraform init

terraform plan

terraform apply
```

> output
```
connection_string = "az aks get-credentials --resource-group hashitalks2023 --name tooling-cluster"
```

### Consul
This will first deploy Consul in the GKE cluster. It will bootstrap the Consul cluster and create the federation Kubernetes secret that will be used in the AKS cluster. Once Consul is running in GKE, Terraform will then begin deploying Consul in AKS. Upon completion, two Consul clusters will be deployed in each Kubernetes cluster with Mesh Gateways joining them.

```bash
# in the consul/ directory

terraform init

terraform plan

terraform apply
```

## Validate Consul
Use the following to validate that the Consul clusters are running as expected.

```bash
consul members -wan
```

> output
```bash
Node                   Address           Status  Type    Build   Protocol  DC     Partition  Segment
consul-server-0.azure  10.244.1.8:8302   alive   server  1.14.2  2         azure  default    <all>
consul-server-0.gcp    10.108.2.8:8302   alive   server  1.14.2  2         gcp    default    <all>
consul-server-1.azure  10.244.0.7:8302   alive   server  1.14.2  2         azure  default    <all>
consul-server-1.gcp    10.108.1.5:8302   alive   server  1.14.2  2         gcp    default    <all>
consul-server-2.azure  10.244.2.10:8302  alive   server  1.14.2  2         azure  default    <all>
consul-server-2.gcp    10.108.0.10:8302  alive   server  1.14.2  2         gcp    default    <all>
```

## Configure Consul DNS in Kubernetes with a Stub Domain
Get the IP address of the DNS service:
```bash
kubectl get svc consul-dns -o jsonpath='{.spec.clusterIP}' 
```

> output
```bash
10.112.12.8
```

### Google Kubernetes Engine (GKE)
Patch the `kube-dns` ConfigMap:
```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"consul": ["10.112.12.8"]}
EOF
```

### Azure Kubernetes Service (AKS)
Create a ConfigMap with custom CoreDNS settings:
```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  consul.server: | # must end with the .server file extension
    consul:53 {
        errors
        cache 30
        forward . 10.0.127.240
    }
EOF

kubectl delete pod --namespace kube-system --selector k8s-app=kube-dns
```