variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node_role_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "node_groups" {
  type = map(object({
    node_group_name  = string
    instance_types   = list(string)
    desired_capacity = number
    min_capacity     = number
    max_capacity     = number
    capacity_type    = string
  }))
}
variable "node_security_group_id" {
  type        = string
  description = "Security group attached to EKS worker nodes"
}