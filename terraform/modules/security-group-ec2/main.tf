resource "aws_security_group" "web" {
  name        = var.sg_name
  description = "Allow Grafana/Prometheus access from LB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Prometheus from LB"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [var.lb_security_group_id]
  }

  ingress {
    description = "Loki from EKS private subnets"
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  # DNS / VPC endpoints egress
  egress {
    description = "DNS to VPC resolver"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "HTTPS to VPC endpoints and internal APIs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


  tags = {
    Name = var.sg_name
  }
}



