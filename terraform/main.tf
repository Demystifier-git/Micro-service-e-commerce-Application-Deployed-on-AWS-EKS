provider "aws" {
  region = var.region
}

# VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
}

# Subnets
module "subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.vpc.vpc_id
  availability_zones = var.availability_zones
}


# Internet Gateway
module "igw" {
  source = "./modules/internet-gateway"
  vpc_id = module.vpc.vpc_id
}

# NAT Gateway
module "nat" {
  source           = "./modules/nat-gateway"
  public_subnet_id = module.subnets.public_subnet_ids[0]
  depends_on       = [module.igw]
}

module "routes" {
  source = "./modules/route-tables"

  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  nat_id = module.nat.nat_id

  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
}

# Security Groups
module "web_sg" {
  source  = "./modules/security-group-web"
  vpc_id  = module.vpc.vpc_id
  sg_name = "web-sg"
}

module "db_sg" {
  source         = "./modules/security-group-db"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "db-new"
  allowed_sg_ids = [module.web_sg.sg_id]
}

module "vpc_sg" {
  source  = "./modules/security-group-VPC"
  vpc_id  = module.vpc.vpc_id
  sg_name = "vpc-sg"
}



# RDS
module "rds" {
  source = "./modules/rds"

  name               = "mysql-db"
  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password
  subnet_ids         = module.subnets.private_subnet_ids
  security_group_ids = [module.db_sg.sg_id]

  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
}

module "s3" {
  source      = "./modules/S3"
  bucket_name = var.bucket_name
  environment = var.environment

  tags = {
    Project = "development-bucket"
    Env     = var.environment
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name   = var.dynamodb_table_name
  hash_key     = var.dynamodb_hash_key
  billing_mode = var.dynamodb_billing_mode
  environment  = var.environment

  tags = {
    Project = "stan-robot-shop"
    Env     = var.environment
  }
}





module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.subnets.private_subnet_ids
  tags            = var.tags
}

module "node_group" {
  source = "./modules/node_group"

  cluster_name = module.eks.cluster_name
  subnet_ids   = module.subnets.private_subnet_ids
  tags         = var.tags


  node_groups   = var.node_groups
  node_role_arn = aws_iam_role.node.arn

  node_security_group_id = aws_security_group.node_sg.id
}

module "irsa" {
  source = "./modules/irsa"

  cluster_name            = module.eks.cluster_name
  oidc_provider_arn       = module.eks.oidc_provider_arn
  oidc_provider_url       = module.eks.oidc_provider_url
  hosted_zone_id          = var.hosted_zone_id
  region                  = var.region
  karpenter_node_role_arn = module.iam.karpenter_node_role_arn

  tags = var.tags
  env = var.environment
}

module "alb" {
  source       = "./modules/alb"
  cluster_name = module.eks.cluster_name
  region       = var.region
  alb_role_arn = module.irsa.alb_role_arn
  vpc_id       = module.vpc.vpc_id
}

module "monitoring" {
  source = "./modules/monitoring"

  namespace = var.namespace

  grafana_hostname    = var.grafana_hostname
  prometheus_hostname = var.prometheus_hostname
  certificate_arn     = var.certificate_arn
}

module "karpenter" {
  source = "./modules/karpenter"

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  namespace        = "karpenter"

  iam_role_arn     = module.irsa.karpenter_role_arn
  instance_profile = module.iam.karpenter_instance_profile_name
}



module "argocd" {
  source = "./modules/argocd"

  repo_url       = var.repo_url
  region         = var.region
  ecr_account_id = var.account_id
  ecr_url        = module.ecr_web_app.repository_url



}

locals {
  secrets = {
    payment   = ["mongodb", "redis"]
    cart      = ["redis"]
    user      = ["mongodb", "redis"]
    catalogue = ["mongodb", ]
    dispatch  = ["rabbitmq", ]
    mongodb   = ["mongodb", ]
    rabbitmq  = ["db", ]
    ratings   = ["mysql", ]
    redis     = ["db", ]
    shipping  = ["mysqldb", ]
    grafana = [
      "admin",
      "smtp"
    ]
  }
}


module "secrets" {
  source = "./modules/secrets-manager"

  for_each = merge([
    for service, purposes in local.secrets : {
      for p in purposes :
      "${service}-${p}" => {
        service = service
        purpose = p
      }
    }
  ]...)

  name        = "${var.environment}/${each.value.service}/${each.value.purpose}"
  environment = var.environment

  secret_value = var.secret_values[each.key]
}

module "external_secrets" {
  source = "./modules/external-secrets"

  env           = var.environment
  region        = var.region
  eks_namespace = var.eks_namespace

  oidc_provider_arn = module.eks.oidc_provider_arn
}




locals {
  services = [
    "web",
    "cart",
    "payment",
    "catalogue",
    "shipping",
    "dispatch"
  ]
}

module "ecr" {
  for_each = toset(local.services)

  source = "./modules/ECR"

  name = each.value

  tags = {
    Environment = var.environment
    Project     = "devops-platform"
  }
}


module "tempo" {
  source = "./modules/tempo"

  namespace = var.namespace
}

module "cloudfront" {

  source = "./modules/cloudfront"

  project_name = var.project_name

  environment = var.environment

  bucket_id = module.frontend_bucket.bucket_id

  bucket_arn = module.frontend_bucket.bucket_arn

  bucket_regional_domain_name = module.frontend_bucket.bucket_regional_domain_name

  acm_certificate_arn = module.acm.certificate_arn

  aliases = [

    "app.delightdavid.online"

  ]

  cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"


}

# Route53
module "route53" {
  source = "./modules/route53"

  domain_name = var.domain_name


}

module "iam" {
  source = "./modules/IAM"

  tags = var.tags
}
