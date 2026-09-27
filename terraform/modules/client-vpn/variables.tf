variable "name" {
  description = "Name of the AWS Client VPN endpoint"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Client VPN will be associated"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used for Client VPN network associations"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required for the Client VPN."
  }
}

variable "client_cidr_block" {
  description = "CIDR range assigned to Client VPN clients"
  type        = string

  validation {
    condition     = can(cidrhost(var.client_cidr_block, 0))
    error_message = "client_cidr_block must be a valid IPv4 CIDR block."
  }
}

variable "server_certificate_arn" {
  description = "ACM ARN of the Client VPN server certificate"
  type        = string
}

variable "tags" {
  description = "Tags applied to Client VPN resources"
  type        = map(string)

  default = {}
}