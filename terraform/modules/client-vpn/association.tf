resource "aws_ec2_client_vpn_network_association" "private" {
  for_each = toset(var.private_subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id

  subnet_id = each.value
}