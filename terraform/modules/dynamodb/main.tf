resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key


  attribute {
    name = var.hash_key
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  tags = merge(
    {
      Name        = var.table_name
      Environment = var.environment
    },
    var.tags
  )
}
