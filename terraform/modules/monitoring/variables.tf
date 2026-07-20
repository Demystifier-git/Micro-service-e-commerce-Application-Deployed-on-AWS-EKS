variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_admin_user" {
  type      = string
  sensitive = true
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

variable "smtp_user" {
  type      = string
  sensitive = true
}

variable "smtp_password" {
  type      = string
  sensitive = true
}

variable "smtp_host" {
  type = string
}

variable "smtp_from" {
  type = string
}



variable "grafana_hostname" {
  type = string
}

variable "prometheus_hostname" {
  type = string
}

variable "certificate_arn" {
  type = string
}