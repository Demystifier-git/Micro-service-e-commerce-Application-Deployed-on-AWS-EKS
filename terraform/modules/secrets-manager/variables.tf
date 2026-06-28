

variable "name" {
  description = "Secret name path (e.g. grafana/admin-password)"
  type        = string
}

variable "environment" {
  description = "denvironment for secrets"
  type        = string
}