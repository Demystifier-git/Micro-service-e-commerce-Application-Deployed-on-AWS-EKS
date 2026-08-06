terraform {
  backend "s3" {
    bucket         = "minishop-prod-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "minishop-prod-terraform-locks"
    encrypt        = true
<<<<<<< HEAD

=======
>>>>>>> d7730488605cb98528c9e5daf478bd82993b4e9d

  }
}
