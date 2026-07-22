variable "namespace" {
  type    = string
  default = "monitoring"
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