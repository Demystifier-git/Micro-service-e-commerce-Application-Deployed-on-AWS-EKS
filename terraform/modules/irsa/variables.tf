variable "oidc_issuer" {
  description = "EKS OIDC issuer URL"
}

variable "cluster_name" {
  description = "EKS cluster name"
}

variable "env" {
  type = string
}

variable "role_name" {
  type        = string
  description = "Name of the IAM role for IRSA"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN from EKS cluster"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC issuer URL from EKS cluster"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for service account"
}

variable "service_account" {
  type        = string
  description = "Kubernetes service account name"
}