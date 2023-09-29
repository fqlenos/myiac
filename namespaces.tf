# Define usable namespaces

# Web namespace
resource "kubernetes_namespace" "www" {

  depends_on = [
    time_sleep.wait_for_kubernetes
  ]

  metadata {
    name = "www"
  }
}

# Certmanager namespace
resource "kubernetes_namespace" "certmanager" {

  depends_on = [
    time_sleep.wait_for_kubernetes
  ]

  metadata {
    name = "certmanager"
  }

}

# Traefik namespace
resource "kubernetes_namespace" "traefik" {

  depends_on = [
    time_sleep.wait_for_kubernetes
  ]

  metadata {
    name = "traefik"
  }
}
