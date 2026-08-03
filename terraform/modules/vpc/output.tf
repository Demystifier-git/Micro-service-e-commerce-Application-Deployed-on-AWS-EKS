

output "vpc_id" {
  value = aws_vpc.this.id
}


output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "private_route_tables" {
  value = aws_route_table.private[*].id
}

