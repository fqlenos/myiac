# Nginx Deployment

resource "kubernetes_deployment" "nginx" {

  depends_on = [
    kubernetes_namespace.www
  ]

  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.www.metadata[0].name
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {

  depends_on = [
    kubernetes_namespace.www
  ]

  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.www.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }
    port {
      port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubectl_manifest" "nginx-certificate" {

  depends_on = [kubernetes_namespace.www, time_sleep.wait_for_clusterissuer]

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx
  namespace: "${kubernetes_namespace.www.metadata[0].name}"
spec:
  secretName: nginx
  issuerRef:
    name: cloudflare-prod
    kind: ClusterIssuer
  dnsNames:
  - 'www."${var.domain}"'   
    YAML
}


resource "kubernetes_ingress_v1" "nginx" {

  depends_on = [kubernetes_namespace.www]

  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.www.metadata[0].name
  }

  spec {
    rule {

      host = "www.${var.domain}"

      http {

        path {
          path = "/"

          backend {
            service {
              name = "nginx"
              port {
                number = 80
              }
            }
          }

        }
      }
    }

    tls {
      secret_name = "nginx"
      hosts       = ["www.${var.domain}"]
    }
  }
}

resource "cloudflare_record" "www-main-cluster" {
  zone_id = var.cloudflare_zone_id
  name    = "www.${var.domain}"
  value   = data.civo_loadbalancer.traefik_lb.public_ip
  type    = "A"
  proxied = true
}
