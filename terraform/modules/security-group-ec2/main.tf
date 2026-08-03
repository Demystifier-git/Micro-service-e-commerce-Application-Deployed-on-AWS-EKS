resource "aws_security_group" "web" {
  name   = var.sg_name
  description = "Allow Promtail and Otel traffic from EKS and allow grafana and promtail to be accessed on browser"
  vpc_id = var.vpc_id

  ingress {
    description = "Loki logs"
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

   ingress {
    description = "Prometheus metrics"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  ingress {
    description = "Tempo traces"
    from_port   = 4317
    to_port     = 4317
    protocol    = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  ingress {
    description = "prometheus"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [var.lb_security_group_id]
  }

   ingress {
    description = "grafana"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [var.lb_security_group_id]
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