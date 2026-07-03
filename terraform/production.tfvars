# AWS region
region = "us-east-1"

# Networking
vpc_cidr = "10.0.0.0/16"
availability_zones = [
  "us-east-1a",
  "us-east-1b"
]





# Tags (optional but common)
environment = "dev"

db_engine_version    = "8.0"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20

bucket_name   = "demystifier-bucket-387041334219"
bucket_region = "us-east-1"

dynamodb_table_name   = "terraform-demo-table"
dynamodb_hash_key     = "id"
dynamodb_billing_mode = "PAY_PER_REQUEST"
cluster_name          = "development-cluster"
cluster_version       = "1.33"



endpoint_private_access = true
endpoint_public_access  = true

tags = {
  Environment = "production"
  Project     = "eks-cluster"
  Owner       = "devops-team"
  ManagedBy   = "terraform"
}

node_groups = {
  ondemand = {
    node_group_name  = "on-demand-nodes"
    instance_types   = ["m7i-flex.large"]
    desired_capacity = 2
    min_capacity     = 1
    max_capacity     = 3
    capacity_type    = "ON_DEMAND"
  }
}

eks_namespace = "external-secrets"
account_id    = "387041334219"
repo_url      = "https://github.com/Demystifier-git/Micro-service-E_commerce-Application-Deployed-on-AWS-EKS.git"
namespace     = "monitoring"

