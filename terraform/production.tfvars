# AWS region
region = "us-east-1"

# Networking
vpc_cidr = "10.0.0.0/16"
availability_zones = [
  "us-east-1a",
  "us-east-1b"
]





# Tags (optional but common)
environment = "production"

db_engine_version    = "8.0"
db_instance_class    = "db.t3.medium"
db_allocated_storage = 20

bucket_name = "demystifier-bucket-387041334219"


dynamodb_table_name   = "terraform-demo-table"
dynamodb_hash_key     = "id"
dynamodb_billing_mode = "PAY_PER_REQUEST"
cluster_name          = "production-cluster"
cluster_version       = "1.33"





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
repo_url      = "https://github.com/Demystifier-git/Micro-service-E_commerce-Application-Deployed-on-AWS-EKS.git"
namespace     = "monitoring"

domain_name = "delightdavid.online"

grafana_hostname    = "grafana.delightdavid.online"
prometheus_hostname = "prometheus.delightdavid.online"

certificate_arn = "arn:aws:acm:us-east-1:387041334219:certificate/e2dc15a3-8532-4239-b58e-60aa7caab0f5"
account_id      = "387041334219"
project_name    = "robot-shop"
