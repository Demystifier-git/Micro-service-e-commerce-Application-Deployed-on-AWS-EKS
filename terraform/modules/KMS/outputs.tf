output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = aws_kms_key.main.arn
}

output "kms_key_id" {
  description = "ID of the KMS key"
  value       = aws_kms_key.main.id
}

output "kms_key_key_id" {
  description = "KMS Key ID"
  value       = aws_kms_key.main.key_id
}

output "kms_alias" {
  description = "KMS alias"
  value       = aws_kms_alias.main.name
}