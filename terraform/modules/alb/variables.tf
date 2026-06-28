variable "cluster_name" {}
variable "region" {}

variable "alb_role_arn" {
  description = "IAM role ARN for ALB controller (from IRSA module)"
}

variable "vpc_id" {
  type = string
}