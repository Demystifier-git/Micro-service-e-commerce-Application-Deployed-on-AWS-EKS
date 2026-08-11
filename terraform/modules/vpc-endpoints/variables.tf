variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }

variable "region" {}
variable "node_sg_id" { description = "EKS node security group ID" }
variable "public_route_table_id" {
  type = string
}

variable "private_route_table_id" {
  type = string
}

variable "web_sg_id" {
  description = "Security Group ID for EC2 runner (web SG)"
  type        = string
}


