output "node_group_names" {
  value = {
    for k, ng in aws_eks_node_group.this :
    k => ng.node_group_name
  }
}

output "node_security_group_id" {
  description = "Security group attached to EKS worker nodes"
  value       = var.node_security_group_id
}


