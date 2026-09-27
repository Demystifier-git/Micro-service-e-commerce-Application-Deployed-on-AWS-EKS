resource "aws_ec2_client_vpn_route" "vpc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id

  destination_cidr_block = var.vpc_cidr_block

  target_vpc_subnet_id = var.private_subnet_ids[0]

  description = "Route VPN clients to production VPC"
}