variable "tags" {

  description = "Tags applied to IAM resources."

  type = map(string)

  default = {}
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

