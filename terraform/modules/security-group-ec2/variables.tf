variable "vpc_id" {}
variable "vpc_cidr" {
  description = "VPC CIDR (used for egress to VPC endpoints)"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs where EKS nodes run"
  type        = list(string)
  default     = []
}

variable "lb_security_group_id" {
  description = "Load balancer security group id"
  type        = string
}

variable "sg_name" {
  type = string
}

