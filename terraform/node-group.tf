
# NODE SECURITY GROUP (Hardened)


resource "aws_security_group" "node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.vpc.vpc_id

  # Restrict outbound traffic to only what is required:
  # - Monitoring EC2 SG (Loki, Prometheus, Tempo, Grafana)
  # - AWS VPC endpoints (ECR, S3, STS, etc.)

  # Loki logs
  egress {
    from_port       = 3100
    to_port         = 3100
    protocol        = "tcp"
    security_groups = [module.web_sg.security_group_id] # EC2 SG output
    description     = "Send logs to Loki"
  }

  # Prometheus metrics
  egress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [module.web_sg.security_group_id]
    description     = "Send metrics to Prometheus"
  }

  # Tempo traces
  egress {
    from_port       = 4317
    to_port         = 4317
    protocol        = "tcp"
    security_groups = [module.web_sg.security_group_id]
    description     = "Send traces to Tempo"
  }



  # Example: allow HTTPS to AWS VPC endpoints (ECR, S3, STS, etc.)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # replace with your VPC endpoint CIDR
    description = "Allow HTTPS to AWS service endpoints"
  }




  tags = var.tags
}


# ----------------------------
# CLUSTER SECURITY GROUP RULE
# (Allow nodes to talk to control plane)
# ----------------------------

resource "aws_security_group_rule" "cluster_ingress_from_nodes" {
  type        = "ingress"
  description = "Allow worker nodes to communicate with EKS cluster"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = aws_security_group.node_sg.id
}

# ----------------------------
# OPTIONAL: Allow node-to-node communication
# (needed for CNI networking, pod traffic)
# ----------------------------

resource "aws_security_group_rule" "node_to_node" {
  type        = "ingress"
  description = "Allow nodes to communicate with each other"

  from_port = 0
  to_port   = 0
  protocol  = "-1"

  security_group_id = aws_security_group.node_sg.id
  self              = true
}

# ----------------------------
# CLUSTER → RUNNER COMMUNICATION
# ----------------------------
resource "aws_security_group_rule" "cluster_to_runner" {
  type        = "ingress"
  description = "Allow EKS cluster to communicate with runner SG"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Runner SG is the target
  security_group_id        = module.web_sg.security_group_id
  # Cluster SG is the source
  source_security_group_id = module.eks.cluster_security_group_id
}
