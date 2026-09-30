resource "aws_ec2_client_vpn_endpoint" "this" {
  description = var.name

  client_cidr_block = var.client_cidr_block

  vpc_id = var.vpc_id

  server_certificate_arn = var.server_certificate_arn

  split_tunnel = true

  transport_protocol = "udp"

  vpn_port = 443

  security_group_ids = [
    aws_security_group.client_vpn.id
  ]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.server_certificate_arn
  }

  connection_log_options {
    enabled = false
  }

  client_login_banner_options {
    enabled     = true
    banner_text = "Authorized access only."
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}