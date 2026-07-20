output "node_role_arn" {

  description = "EKS worker node IAM role ARN."

  value = aws_iam_role.node.arn
}

output "node_role_name" {

  description = "EKS worker node IAM role name."

  value = aws_iam_role.node.name
}