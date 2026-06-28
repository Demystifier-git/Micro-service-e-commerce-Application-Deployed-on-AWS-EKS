variable "cluster_name" {
  type = string
}

variable "iam_role_arn" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "namespace" {
  type    = string
  default = "karpenter"
}

variable "cluster_endpoint" {
  type = string
}