

output "alb_role_arn" {
  value = aws_iam_role.alb.arn
}



output "role_arn" {
  value       = aws_iam_role.eso_role.arn
  description = "IAM Role ARN created for IRSA"
}

output "role_name" {
  value       = aws_iam_role.eso_role.name
  description = "IAM Role name created for IRSA"
}

output "oidc_provider_arn" {
  value = data.aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  value = data.aws_iam_openid_connect_provider.this.url
}

output "oidc_host" {
  value = replace(
    data.aws_iam_openid_connect_provider.this.url,
    "https://",
    ""
  )
}

output "karpenter_role_arn" {
  value = aws_iam_role.karpenter.arn
}