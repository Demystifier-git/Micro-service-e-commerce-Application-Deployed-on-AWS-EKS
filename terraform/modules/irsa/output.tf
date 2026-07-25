

output "alb_role_arn" {
  value = aws_iam_role.alb.arn
}



output "role_arn" {
  description = "External Secrets Operator IAM Role ARN"
  value       = aws_iam_role.eso.arn
}

output "role_name" {
  description = "External Secrets Operator IAM Role Name"
  value       = aws_iam_role.eso.name
}

output "oidc_provider_arn" {
  value = var.oidc_provider_arn
}

output "oidc_provider_url" {
  value = var.oidc_provider_url
}

output "oidc_host" {
  value = replace(var.oidc_provider_url, "https://", "")
}

output "karpenter_role_arn" {
  value = aws_iam_role.karpenter.arn
}