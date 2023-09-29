variable "domain" {
  description = "Your main domain"
  type        = string
}

variable "civo_token" {
  description = "CIVO API Key"
  type        = string
}

variable "civo_region" {
  description = "CIVO Region where to deploy infrastructure"
  type        = string
}

variable "cloudflare_email" {
  description = "Cloudflare user's email value"
  type        = string
}

variable "cloudflare_api_key" {
  description = "Cloudflare Global API Key"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "increase_timeout" {
  description = "Some deployments can take long time. Increase the timeout for that cases."
  type        = number
  default     = 800
}
