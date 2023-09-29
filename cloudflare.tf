# Cloudflare DNS records and API Secret

resource "kubernetes_secret" "cloudflare_api_key_secret" {

  depends_on = [
    kubernetes_namespace.certmanager
  ]

  metadata {
    name      = "cloudflare-api-key-secret"
    namespace = kubernetes_namespace.certmanager.metadata[0].name
  }

  data = {
    api-key = var.cloudflare_api_key
  }

  type = "Opaque"
}

