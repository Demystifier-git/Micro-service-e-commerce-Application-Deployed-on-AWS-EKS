# S3 Gateway endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  # Use route table IDs, not subnet IDs
  route_table_ids = [
    var.private_route_table_id,
    var.public_route_table_id
  ]
}



# ECR API Interface endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    var.node_sg_id,
    var.web_sg_id # passed in from root
  ]
}

# ECR DKR Interface endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    var.node_sg_id,
    var.web_sg_id # passed in from root
  ]
}

# STS Interface endpoint
resource "aws_vpc_endpoint" "sts" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    var.node_sg_id,
    var.web_sg_id # passed in from root
  ]
}

# CloudWatch Logs Interface endpoint
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    var.node_sg_id,
    var.web_sg_id # passed in from root
  ]
}

# EC2 Interface endpoint
resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    var.node_sg_id,
    var.web_sg_id # passed in from root
  ]
}

# Autoscaling Interface endpoint
resource "aws_vpc_endpoint" "autoscaling" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.autoscaling"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    var.node_sg_id,
    var.web_sg_id # passed in from root
  ]
}

# KMS Interface endpoint
resource "aws_vpc_endpoint" "kms" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.kms"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    var.node_sg_id,
    var.web_sg_id # passed in from root
  ]
}