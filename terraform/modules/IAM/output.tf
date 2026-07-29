output "node_role_arn" {

  description = "EKS worker node IAM role ARN."

  value = aws_iam_role.node.arn
}

output "node_role_name" {

  description = "EKS worker node IAM role name."

  value = aws_iam_role.node.name
}

output "karpenter_node_role_arn" {
  value = aws_iam_role.karpenter_node.arn
}

output "karpenter_instance_profile_name" {
  value = aws_iam_instance_profile.karpenter.name
}

output "flow_logs_role_arn" {
  value = aws_iam_role.flow_logs.arn
}