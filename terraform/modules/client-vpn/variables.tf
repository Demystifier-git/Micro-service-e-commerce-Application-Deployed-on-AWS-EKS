variable "name" {
  description = "Name of the Client VPN endpoint"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Client VPN will be associated"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs to associate with the Client VPN"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnet IDs are required for high availability."
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "client_cidr_block" {
  description = "CIDR block assigned to VPN clients"
  type        = string
}

variable "server_certificate_arn" {
  description = "ACM certificate ARN used by Client VPN"
  type        = string
}

variable "client_vpn_ca_certificate_path" {
  description = "Path to the Client VPN root CA certificate"
  type        = string
}

variable "tags" {
  description = "Tags applied to Client VPN resources"
  type        = map(string)
  default     = {}
}