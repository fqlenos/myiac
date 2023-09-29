
# whoami Deployment

resource "kubernetes_deployment" "whoami" {

  depends_on = [
    kubernetes_namespace.www
  ]

  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.www.metadata[0].name
    labels = {
      app = "whoami"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "whoami"
      }
    }

    template {
      metadata {
        labels = {
          app = "whoami"
        }
      }

      spec {
        container {
          image = "containous/whoami"
          name  = "whoami"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "whoami" {

  depends_on = [
    kubernetes_namespace.www
  ]

  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.www.metadata[0].name
  }

  spec {
    selector = {
      app = "whoami"
    }
    port {
      port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubectl_manifest" "whoami-certificate" {

  depends_on = [kubernetes_namespace.www, time_sleep.wait_for_clusterissuer]

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: whoami
  namespace: "${kubernetes_namespace.www.metadata[0].name}"
spec:
  secretName: whoami
  issuerRef:
    name: cloudflare-prod
    kind: ClusterIssuer
  dnsNames:
  - 'me."${var.domain}"'   
    YAML
}

resource "kubernetes_ingress_v1" "whoami" {

  depends_on = [kubernetes_namespace.www]

  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.www.metadata[0].name
  }

  spec {
    rule {

      host = "me.${var.domain}"

      http {

        path {
          path = "/"

          backend {
            service {
              name = "whoami"
              port {
                number = 80
              }
            }
          }

        }
      }
    }

    tls {
      secret_name = "whoami"
      hosts       = ["me.${var.domain}"]
    }
  }
}

resource "cloudflare_record" "whoami-main-cluster" {
  zone_id = var.cloudflare_zone_id
  name    = "me.${var.domain}"
  value   = data.civo_loadbalancer.traefik_lb.public_ip
  type    = "A"
  proxied = true
}
