resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/vpc/flowlogs/${var.project_name}-${var.environment}"
  retention_in_days = var.retention_in_days

  tags = var.tags
}

resource "aws_flow_log" "this" {
  vpc_id       = var.vpc_id
  traffic_type = "ALL"

  # Destination type must be cloud-watch-logs
  log_destination_type = "cloud-watch-logs"
  # Use ARN instead of name
  log_destination = aws_cloudwatch_log_group.this.arn

  iam_role_arn = var.iam_role_arn

  tags = var.tags
}
