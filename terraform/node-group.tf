# ----------------------------
# NODE SECURITY GROUP
# ----------------------------

resource "aws_security_group" "node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.vpc.vpc_id

  # Allow ALL outbound traffic (required for:
  # - pulling images from ECR
  # - reaching EKS API
  # - downloading bootstrap scripts)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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