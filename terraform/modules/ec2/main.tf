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
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = [
          "arn:aws:kms:us-east-1:245361884126:key/e552646b-de8e-4dbb-96ed-3b81577b611c"
        ]
        Condition = {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.us-east-1.amazonaws.com"
          }
        }
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
# S3 BUCKET ACCESS POLICY
# ============================================================

resource "aws_iam_policy" "ec2_s3_access" {
  name        = "ec2-s3-access"
  description = "Allow EC2 to read/write to goldstandard bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::goldstandard-bucket-38704133421990202653-logs",  # bucket itself
          "arn:aws:s3:::goldstandard-bucket-38704133421990202653-logs/*" # objects inside bucket
        ]
      }
    ]
  })
}

# ============================================================
# ATTACH S3 POLICY TO EC2 ROLE
# ============================================================

resource "aws_iam_role_policy_attachment" "ec2_s3_access_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_access.arn
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
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

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
