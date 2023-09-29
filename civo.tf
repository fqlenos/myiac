# Kubernetes Cluster

data "civo_size" "xsmall" {

  filter {
    key      = "name"
    values   = ["g4s.kube.xsmall"]
    match_by = "re"
  }
}

resource "civo_kubernetes_cluster" "main_cluster" {
  name         = "main_cluster"
  applications = ""
  firewall_id  = civo_firewall.main_fw.id

  pools {
    node_count = 1
    size       = element(data.civo_size.xsmall.sizes, 0).name
  }
}

resource "civo_firewall" "main_fw" {
  name = "main_fw"

  create_default_rules = false

  ingress_rule {
    protocol   = "tcp"
    port_range = "443"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
    label      = "kubernetes_https"
  }

  ingress_rule {
    protocol   = "tcp"
    port_range = "6443"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
    label      = "kubernetes_api"
  }
}

resource "time_sleep" "wait_for_kubernetes" {

  depends_on = [
    civo_kubernetes_cluster.main_cluster
  ]

  create_duration = "20s"
}

data "civo_loadbalancer" "traefik_lb" {

  depends_on = [
    helm_release.traefik
  ]

  name = "main_cluster-traefik-traefik"
}
