variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "env" {
  description = "Environment name."
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN."
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC Provider URL."
  type        = string
}

variable "region" {
  description = "AWS Region."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID."
  type        = string
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)

  default = {}
}

variable "karpenter_node_role_arn" {
  description = "IAM role ARN used by Karpenter launched nodes"
  type        = string
}