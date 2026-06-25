# Output for Public Route Table
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

# Output for Private Route Table
output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}



# Optional: Output the created routes
output "public_route_id" {
  description = "ID of the public route"
  value       = aws_route.public_route.id
}

output "private_route_id" {
  description = "ID of the private route"
  value       = aws_route.private_route.id
}

output "public_route_table_association_ids" {
  value = [for a in aws_route_table_association.public_assoc : a.id]
}

output "private_route_table_association_ids" {
  value = [for a in aws_route_table_association.private_assoc : a.id]
}
