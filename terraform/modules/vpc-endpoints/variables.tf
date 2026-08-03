variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "private_route_table_ids" { type = list(string) }
variable "region" {}
variable "node_sg_id" { description = "EKS node security group ID" }