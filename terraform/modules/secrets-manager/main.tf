resource "aws_secretsmanager_secret" "this" {
  name = "${var.environment}/${var.name}-${terraform.workspace}"

  
}