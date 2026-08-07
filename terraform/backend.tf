terraform {
  backend "s3" {
    bucket         = "minishop-prod-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "minishop-prod-terraform-locks-2"
    encrypt        = true

  }
}
