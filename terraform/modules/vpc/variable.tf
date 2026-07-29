variable "cidr_block" {}
variable "environment" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "project_name" {
  type = string
}

variable "flow_logs_role_arn" {
  type = string
}

