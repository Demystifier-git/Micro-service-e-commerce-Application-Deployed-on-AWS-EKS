
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  
}

variable "availability_zones" {
  description = "List of availability zones to create subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}





variable "db_username" {
  description = "Username for RDS database"
  type        = string
}


variable "db_name" {
  description = "Username for RDS database"
  type        = string
}

variable "db_password" {
  description = "Password for RDS database"
  type        = string
  sensitive   = true
}

variable "db_engine_version" {
  description = "The database engine version for RDS"
  type        = string
}

variable "db_instance_class" {
  description = "The instance class/type for RDS"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage (in GB) for RDS"
  type        = number
}


variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}




variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "dynamodb_billing_mode" {
  description = "Billing mode for DynamoDB (PAY_PER_REQUEST or PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_hash_key" {
  description = "Partition key for the DynamoDB table"
  type        = string
}

variable "cluster_name" {
  description = "Name of cluster"
  type        = string
}

variable "cluster_version" {
  description = "Name of cluster"
  type        = string
}





variable "tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}

variable "node_groups" {
  type = map(object({
    node_group_name  = string
    instance_types   = list(string)
    desired_capacity = number
    min_capacity     = number
    max_capacity     = number
    capacity_type    = string
  }))
}

variable "eks_namespace" {
  type    = string
  default = "external-secrets"
}





variable "namespace" {
  type = string
}

variable "secret_values" {
  description = "Map of secret values to populate AWS Secrets Manager"
  type        = map(any)
  sensitive   = true
}

variable "project_name" {
  type = string
}



variable "grafana_hostname" {
  description = "Hostname for Grafana"
  type        = string
}

variable "prometheus_hostname" {
  description = "Hostname for Prometheus"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN used by monitoring ingress"
  type        = string
}

variable "account_id" {
  description = "account id"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt the RDS instance"
  type        = string
}








