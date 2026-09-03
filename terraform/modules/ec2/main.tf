# ============================================================
# IAM ROLE FOR EC2
# ============================================================

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# ============================================================
# SSM ACCESS
# ============================================================

resource "aws_iam_role_policy_attachment" "ec2_ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# ============================================================
# RDS READ-ONLY ACCESS
# ============================================================

resource "aws_iam_role_policy_attachment" "ec2_rds_readonly_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}


# ============================================================
# SECRETS MANAGER - SPECIFIC SECRETS ONLY
# ============================================================

resource "aws_iam_policy" "ec2_secretsmanager_specific" {
  name        = "ec2-secretsmanager-specific"
  description = "Allow EC2 to read only specific Secrets Manager secrets"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]

        Resource = [
          "arn:aws:secretsmanager:us-east-1:245361884126:secret:production/production/mysql_exporter/default-default-*",
          "arn:aws:secretsmanager:us-east-1:245361884126:secret:production/production/grafana/default-default-*"
        ]
      }
    ]
  })
}


# ============================================================
# ATTACH SECRETS MANAGER POLICY TO EC2 ROLE
# ============================================================

resource "aws_iam_role_policy_attachment" "ec2_secretsmanager_specific_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_secretsmanager_specific.arn
}


# ============================================================
# EC2 INSTANCE PROFILE
# ============================================================

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}


# ============================================================
# EC2 INSTANCE
# ============================================================

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash

              # Update package lists
              apt-get update -y

              # Install snap if not already installed
              apt-get install -y snapd

              # Install SSM Agent
              snap install amazon-ssm-agent --classic

              # Enable and start SSM Agent
              systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
              systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
              EOF

  tags = {
    Name = var.ec2_name
  }
}
