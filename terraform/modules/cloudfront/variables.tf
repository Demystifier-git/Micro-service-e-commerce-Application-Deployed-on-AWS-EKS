variable "project_name" {}

variable "environment" {}

variable "bucket_id" {}

variable "bucket_arn" {}

variable "bucket_regional_domain_name" {}

variable "acm_certificate_arn" {}

variable "aliases" {

  type = list(string)

  default = []
}

variable "cache_policy_id" {}

variable "tags" {

  type = map(string)

  default = {}
}