output "client_vpn_endpoint_id" {
  description = "AWS Client VPN endpoint ID"
  value       = aws_ec2_client_vpn_endpoint.this.id
}

output "client_vpn_dns_name" {
  description = "AWS Client VPN endpoint DNS name"
  value       = aws_ec2_client_vpn_endpoint.this.dns_name
}

output "client_vpn_security_group_id" {
  description = "Security group ID attached to the Client VPN"
  value       = aws_security_group.client_vpn.id
}

output "client_vpn_client_cidr" {
  description = "CIDR assigned to VPN clients"
  value       = var.client_cidr_block
}