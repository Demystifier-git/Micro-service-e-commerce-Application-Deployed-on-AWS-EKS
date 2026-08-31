resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier        = var.name
  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.username
  password = var.password

  storage_encrypted       = true
  kms_key_id              = var.kms_key_arn
  backup_retention_period = 0
  deletion_protection     = true

  vpc_security_group_ids                = var.security_group_ids
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  performance_insights_enabled          = false
  performance_insights_kms_key_id       = var.kms_key_arn
  performance_insights_retention_period = 7

  skip_final_snapshot = true
  publicly_accessible = false
  multi_az            = false

  tags = {
    Name = var.name
  }
}
