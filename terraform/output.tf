output "vpc_id" { value = module.vpc.vpc_id }

output "public_subnet_ids" {
  description = "List of public subnet IDs from the subnet module"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs from the subnet module"
  value       = module.subnets.private_subnet_ids
}

# S3 outputs
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

# DynamoDB outputs
output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.dynamodb.table_arn
}

# EC2 outputs
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = module.ec2.public_ip
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.db_endpoint
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.rds.db_id
}

output "node_group_names" {
  value = module.node_group.node_group_names
}

output "cluster_security_group_id" {
  value = aws_security_group.node_sg.id
}

output "oidc_provider_arn" {
  value = module.irsa.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.irsa.oidc_provider_url
}

output "alb_irsa_role_arn" {
  value = module.irsa.alb_role_arn
}

output "alb_controller_role_arn" {
  value = module.irsa.alb_role_arn
}



output "alb_service_account" {
  value = module.alb.service_account_name
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "external_secrets_namespace" {
  value = module.external_secrets.namespace
}

output "ecr_repository_url" {
  value = module.ecr_web_app.repository_url
}

output "ecr_repository_name" {
  value = module.ecr_web_app.repository_name
}







