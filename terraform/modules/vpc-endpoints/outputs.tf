output "endpoint_ids" {
  description = "All VPC endpoint IDs"
  value = {
    s3          = aws_vpc_endpoint.s3.id
    ecr_api     = aws_vpc_endpoint.ecr_api.id
    ecr_dkr     = aws_vpc_endpoint.ecr_dkr.id
    sts         = aws_vpc_endpoint.sts.id
    logs        = aws_vpc_endpoint.logs.id
    ec2         = aws_vpc_endpoint.ec2.id
    autoscaling = aws_vpc_endpoint.autoscaling.id
    kms         = aws_vpc_endpoint.kms.id
  }
}