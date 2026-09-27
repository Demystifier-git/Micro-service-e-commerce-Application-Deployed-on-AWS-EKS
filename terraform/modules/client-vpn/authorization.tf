resource "aws_ec2_client_vpn_authorization_rule" "vpc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id

  target_network_cidr = var.vpc_cidr_block

  authorize_all_groups = true

  description = "Allow certificate-authenticated VPN clients to access production VPC"
}