
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to create subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


variable "key_name" {
  description = "The name of the SSH key pair for EC2 instances"
  type        = string
}

variable "ec2_ami" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
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

variable "bucket_region" {
  description = "Region where the S3 bucket will be created"
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


variable "endpoint_private_access" {
  description = "Enable private access to the Kubernetes API server"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Enable public access to the Kubernetes API server"
  type        = bool
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

variable "irsa_role_name" {
  type    = string
  default = "external-secrets-irsa-role"
}

variable "irsa_service_account" {
  type    = string
  default = "external-secrets-sa"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "repo_url" {
  description = "GitOps repository URL"
  type        = string
}

variable "namespace" {
  type = string
}





