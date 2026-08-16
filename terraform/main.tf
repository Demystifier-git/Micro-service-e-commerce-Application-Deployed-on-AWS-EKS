provider "aws" {
  region = var.region
}

# VPC
module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = var.vpc_cidr
  kms_key_arn        = module.kms.kms_key_arn
  environment        = var.environment
  project_name       = var.project_name
  tags               = var.tags
  flow_logs_role_arn = module.iam.flow_logs_role_arn
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



module "db_sg" {
  source  = "./modules/security-group-db"
  vpc_id  = module.vpc.vpc_id
  sg_name = "db-new"
  allowed_sg_ids = [
    module.node_group.node_security_group_id
  ]
  vpc_cidr = var.vpc_cidr

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
  kms_key_arn        = module.kms.kms_key_arn


  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
}

module "s3" {
  source      = "./modules/S3"
  bucket_name = var.bucket_name
  environment = var.environment
  kms_key_arn = module.kms.kms_key_arn


  tags = {
    Project = "production-bucket"
    Env     = var.environment
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name   = var.dynamodb_table_name
  hash_key     = var.dynamodb_hash_key
  billing_mode = var.dynamodb_billing_mode
  environment  = var.environment
  kms_key_arn  = module.kms.kms_key_arn

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
  kms_key_arn     = module.kms.kms_key_arn
  tags            = var.tags
}

module "node_group" {
  source = "./modules/node_group"

  cluster_name = module.eks.cluster_name
  subnet_ids   = module.subnets.private_subnet_ids
  tags         = var.tags


  node_groups   = var.node_groups
  node_role_arn = module.iam.node_role_arn

  node_security_group_id = aws_security_group.node_sg.id

}

module "irsa" {
  source = "./modules/irsa"

  cluster_name            = module.eks.cluster_name
  oidc_provider_arn       = module.eks.oidc_provider_arn
  oidc_provider_url       = module.eks.oidc_issuer
  region                  = var.region
  karpenter_node_role_arn = module.iam.karpenter_node_role_arn
  account_id              = var.account_id
  environment             = var.environment

  tags = var.tags
  env  = var.environment
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

  providers = {
    kubernetes = kubernetes
    helm       = helm
    kubectl    = kubectl
  }


}

module "karpenter" {
  source = "./modules/karpenter"

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  namespace        = "karpenter"

  iam_role_arn     = module.irsa.karpenter_role_arn
  instance_profile = module.iam.karpenter_instance_profile_name

  providers = {
    kubernetes = kubernetes
    helm       = helm
    kubectl    = kubectl
  }
}



module "argocd" {
  source = "./modules/argocd"
}

locals {
  secrets = {
    mongodb  = ["db", ]
    rabbitmq = ["db", ]
    redis    = ["db", ]
    mysql    = ["db", ]

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
  kms_key_arn = module.kms.kms_key_arn

  secret_value = var.secret_values[each.key]
}

module "external_secrets" {
  source = "./modules/external-secrets"

  env           = var.environment
  region        = var.region
  eks_namespace = var.eks_namespace

  oidc_provider_arn = module.eks.oidc_provider_arn
  providers = {
    kubernetes = kubernetes
    helm       = helm
    kubectl    = kubectl
  }
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

  name        = each.value
  kms_key_arn = module.kms.kms_key_arn

  tags = {
    Environment = var.environment
    Project     = "devops-platform"
  }
}







module "iam" {
  source = "./modules/IAM"

  tags         = var.tags
  environment  = var.environment
  project_name = var.project_name


}

module "kms" {
  source = "./modules/KMS"

  project_name = var.project_name
  environment  = var.environment
}

module "flowlogs" {
  source = "./modules/flowlogs"

  vpc_id       = module.vpc.vpc_id
  iam_role_arn = module.iam.flow_logs_role_arn

  project_name = var.project_name
  environment  = var.environment

  tags = var.tags
}

# EC2
module "ec2" {
  source = "./modules/ec2"

  ec2_name = var.ec2_name


  # EC2 expects ONE subnet
  subnet_id = module.subnets.private_subnet_ids[0]

  security_group_ids = [module.web_sg.security_group_id]

  ami           = var.ec2_ami
  instance_type = var.instance_type
  key_name      = null
}

# Security Groups
module "web_sg" {
  source = "./modules/security-group-ec2"

  vpc_id  = module.vpc.vpc_id
  sg_name = "ec2-sg"

  lb_security_group_id = module.lb_ssl.lb_security_group_id
  vpc_cidr             = module.vpc.vpc_cidr



}

# Load Balancer + SSL
module "lb_ssl" {
  source = "./modules/lb_ssl"

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.subnets.public_subnet_ids

  target_instance_id = module.ec2.instance_id

  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn

}

# Route53
module "route53" {
  source = "./modules/route53"

  hosted_zone_id = var.hosted_zone_id

  domain_name = var.domain_name


  lb_dns_name = module.lb_ssl.lb_dns_name
  lb_zone_id  = module.lb_ssl.lb_zone_id
}


module "vpc_endpoints" {
  source = "./modules/vpc-endpoints"
  vpc_id = module.vpc.vpc_id
  # Pass route table IDs from routes module
  private_subnet_ids     = module.subnets.private_subnet_ids
  public_route_table_id  = module.routes.public_route_table_id
  private_route_table_id = module.routes.private_route_table_id
  region                 = var.region
  node_sg_id             = aws_security_group.node_sg.id
  web_sg_id              = module.web_sg.security_group_id
}




module "external_dns" {
  source                = "./modules/external-dns"
  cluster_name          = var.cluster_name
  external_dns_role_arn = module.irsa.external_dns_role_arn # <-- use your IRSA module output
  domain_filters        = [var.domain_name]                 # e.g. delightdavid.online

  providers = {
    kubernetes = kubernetes
    helm       = helm

  }
}


