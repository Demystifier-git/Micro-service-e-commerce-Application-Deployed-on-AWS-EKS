resource "aws_security_group" "vpc" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow all traffic from trusted security groups"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.allowed_sg_ids
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}
