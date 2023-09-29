# myiac

`myiac` aims to provide hands-on learning experiences using Kubernetes with Terraform.  

The goal is to find solutions that are compatible with any cloud provider. 
While this may be an ideal scenario, Kubernetes can currently be used with one of these technologies to deploy the same infrastructure, irrespective of the provider.

> Note: needless to say, modifications will always be necessary to adapt the configurations to the chosen cloud provider.

It is recommended to look for the specific configurations for each cloud provider at: https://registry.terraform.io/browse/providers.

## Setup
For the current setup, you will need to add several credentials and private configuration details.  
For this, you may want to either edit the `variables.tf` or create a file named `credentials.auto.tfvars` with the following structure:
```
# credentials.auto.tfvars
domain             = "example.com"
civo_token         = "************"
civo_region        = "************"
cloudflare_email   = "you@example.com"
cloudflare_api_key = "************"
cloudflare_zone_id = "************"
```

In this case, [CIVO](https://www.civo.com/) has been used as cloud provider and [Cloudflare](https://cloudflare.com/) as CDN.  
You can find extra information about the resources used in [Resources](#Resources).

## Architecture
It has been decided to deploy a load balancer with [Traefik](https://doc.traefik.io/traefik/). This will work as an ingress controller and will enforce secure communications.  
As PoC two services will be set up, a basic web server with NGINX and a Whoami server. Both services will be deployed with their certificate and subdomain.

> _Whoami is a tiny webserver that prints os information and HTTP request to output._

## Terraform Basic Execution
Clone (or fork) this repo.
As pre-commits are included, you may want to launch:
```bash
$ cd myiac/
$ pre-commit install
$ pre-commit install-hooks
```

In order to build up the entire infrastructure dynamically, you can launch:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_civo"></a> [civo](#requirement\_civo) | ~> 1.0.13 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.14.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_civo"></a> [civo](#provider\_civo) | ~> 1.0.13 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.14.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [civo_firewall.main_fw](https://registry.terraform.io/providers/civo/civo/latest/docs/resources/firewall) | resource |
| [civo_kubernetes_cluster.main_cluster](https://registry.terraform.io/providers/civo/civo/latest/docs/resources/kubernetes_cluster) | resource |
| [cloudflare_record.whoami-main-cluster](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.www-main-cluster](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [helm_release.certmanager](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [helm_release.traefik](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubectl_manifest.cloudflare_prod](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.nginx-certificate](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.whoami-certificate](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_deployment.nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/deployment) | resource |
| [kubernetes_deployment.whoami](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/deployment) | resource |
| [kubernetes_ingress_v1.nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.whoami](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.certmanager](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.traefik](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.www](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/namespace) | resource |
| [kubernetes_secret.cloudflare_api_key_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/secret) | resource |
| [kubernetes_service.nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/service) | resource |
| [kubernetes_service.whoami](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/service) | resource |
| [time_sleep.wait_for_certmanager](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_clusterissuer](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_kubernetes](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [civo_loadbalancer.traefik_lb](https://registry.terraform.io/providers/civo/civo/latest/docs/data-sources/loadbalancer) | data source |
| [civo_size.xsmall](https://registry.terraform.io/providers/civo/civo/latest/docs/data-sources/size) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_civo_region"></a> [civo\_region](#input\_civo\_region) | CIVO Region where to deploy infrastructure | `string` | n/a | yes |
| <a name="input_civo_token"></a> [civo\_token](#input\_civo\_token) | CIVO API Key | `string` | n/a | yes |
| <a name="input_cloudflare_api_key"></a> [cloudflare\_api\_key](#input\_cloudflare\_api\_key) | Cloudflare Global API Key | `string` | n/a | yes |
| <a name="input_cloudflare_email"></a> [cloudflare\_email](#input\_cloudflare\_email) | Cloudflare user's email value | `string` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare Zone ID | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Your main domain | `string` | n/a | yes |
| <a name="input_increase_timeout"></a> [increase\_timeout](#input\_increase\_timeout) | Some deployments can take long time. Increase the timeout for that cases. | `number` | `800` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->