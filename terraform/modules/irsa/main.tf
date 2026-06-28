############################
# USE EXISTING OIDC (DO NOT CREATE NEW ONE)
############################

data "aws_iam_openid_connect_provider" "this" {
  arn = var.oidc_provider_arn
}

locals {
  oidc_host = replace(var.oidc_provider_url, "https://", "")
}

############################
# GENERIC IRSA ASSUME ROLE (CLEANED)
############################

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:aud"

      values = ["sts.amazonaws.com"]
    }
  }
}

############################
# ESO ROLE (IRSA)
############################

resource "aws_iam_role" "eso_role" {
  name               = "eso-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

############################
# ESO POLICY
############################

resource "aws_iam_policy" "secrets_policy" {
  name = "eso-policy-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = "*"
    }]
  })
}

############################
# ATTACH POLICY (MISSING IN YOUR CODE)
############################

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso_role.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}

############################
# ALB ROLE (IRSA CLEANED)
############################

resource "aws_iam_role" "alb" {
  name = "eks-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = var.oidc_provider_arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "${local.oidc_host}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${local.oidc_host}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}