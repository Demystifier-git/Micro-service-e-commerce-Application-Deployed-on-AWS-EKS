variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "namespace" {
  type    = string
  default = "karpenter"
}

variable "iam_role_arn" {
  description = "IRSA IAM role ARN for the Karpenter service account"
  type        = string
}

variable "instance_profile" {
  description = "EC2 instance profile used by Karpenter launched nodes"
  type        = string
}