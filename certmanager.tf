# Certmanager deployment

resource "helm_release" "certmanager" {

  depends_on = [
    kubernetes_namespace.certmanager
  ]

  name      = "certmanager"
  namespace = kubernetes_namespace.certmanager.metadata[0].name

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  # Install Kubernetes CRDs
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "time_sleep" "wait_for_certmanager" {

  depends_on = [
    helm_release.certmanager
  ]

  create_duration = "10s"
}

# Create a ClusterIssuer

resource "kubectl_manifest" "cloudflare_prod" {

  depends_on = [
    time_sleep.wait_for_certmanager
  ]


  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cloudflare-prod
spec:
  acme:
    email: "${var.cloudflare_email}"
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: cloudflare-prod-account-key
    solvers:
    - dns01:
        cloudflare:
          email: "${var.cloudflare_email}"
          apiKeySecretRef:
            name: cloudflare-api-key-secret
            key: api-key
    YAML
}

resource "time_sleep" "wait_for_clusterissuer" {

  depends_on = [
    kubectl_manifest.cloudflare_prod
  ]

  create_duration = "30s"
}