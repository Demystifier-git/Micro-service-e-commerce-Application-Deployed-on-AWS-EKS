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
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20

bucket_name = "goldstandard-bucket-38704133421990202653"


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

namespace = "monitoring"

domain_name = "delightdavid.online"

grafana_hostname    = "grafana.delightdavid.online"
prometheus_hostname = "prometheus.delightdavid.online"

certificate_arn = "arn:aws:acm:us-east-1:245361884126:certificate/0b18d99a-575e-4038-a99c-dd49419d3df0"
account_id      = "387041334219"
project_name    = "robot-shop"

ec2_name = "self-hosted-runner/monitoring-server"

hosted_zone_id = "Z03671882FOPUGI39PA4D"
ec2_ami        = "ami-0b6c6ebed2801a5cb"
instance_type  = "m7i-flex.large"

