terraform {

  required_version = ">= 0.13.0"

  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.0.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.14.0"
    }
  }
}

provider "civo" {
  token  = var.civo_token
  region = var.civo_region
}

provider "helm" {
  kubernetes {
    host                   = yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).clusters.0.cluster.server
    client_certificate     = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).users.0.user.client-certificate-data)
    client_key             = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).users.0.user.client-key-data)
    cluster_ca_certificate = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).clusters.0.cluster.certificate-authority-data)
  }
}

provider "kubernetes" {
  host                   = yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).clusters.0.cluster.server
  client_certificate     = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).users.0.user.client-certificate-data)
  client_key             = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).clusters.0.cluster.certificate-authority-data)
}

provider "kubectl" {
  host                   = yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).clusters.0.cluster.server
  client_certificate     = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).users.0.user.client-certificate-data)
  client_key             = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).users.0.user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(civo_kubernetes_cluster.main_cluster.kubeconfig).clusters.0.cluster.certificate-authority-data)
  load_config_file       = false
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
