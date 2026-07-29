variable "vpc_id" {}
variable "sg_name" {}
variable "allowed_sg_ids" {
  type = list(string)
}
variable "vpc_cidr" {
  type = string
}
