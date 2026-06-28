variable "cluster_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_host" {
  type = string
}

variable "eks_dependency" {
  type = any
}