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
