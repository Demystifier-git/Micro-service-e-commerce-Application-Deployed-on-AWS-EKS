terraform {
  backend "s3" {
    bucket         = "prod-terraform-state-245361884126 "
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prod-terraform-locks"
  }
}
