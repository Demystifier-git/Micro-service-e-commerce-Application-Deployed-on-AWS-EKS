variable "cluster_name" {
  type = string
}

variable "external_dns_role_arn" {
  type = string
}

variable "domain_filters" {
  type    = list(string)
  default = []
}
