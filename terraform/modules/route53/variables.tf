variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "Main domain name"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the application"
  type        = string
}

variable "lb_dns_name" {
  description = "Load balancer DNS name"
  type        = string
}

variable "lb_zone_id" {
  description = "Load balancer zone ID"
  type        = string
}

output "fqdn" {
  value = aws_route53_record.app.fqdn
}