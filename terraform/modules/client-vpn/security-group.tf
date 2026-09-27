resource "aws_security_group" "client_vpn" {
  name        = "${var.name}-sg"
  description = "Security group for AWS Client VPN"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-sg"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "client_vpn_vpc" {
  security_group_id = aws_security_group.client_vpn.id

  cidr_ipv4 = var.vpc_cidr_block

  ip_protocol = "-1"

  description = "Allow VPN clients to reach the production VPC"
}