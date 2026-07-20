####################################
# External Secrets Operator
# Trust Policy
####################################

data "aws_iam_policy_document" "eso_assume" {

  statement {

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${local.oidc_host}:sub"

      values = [
        "system:serviceaccount:external-secrets:external-secrets"
      ]
    }

    condition {

      test = "StringEquals"

      variable = "${local.oidc_host}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

####################################
# IAM Role
####################################

resource "aws_iam_role" "eso" {

  name = "${var.cluster_name}-external-secrets"

  assume_role_policy = data.aws_iam_policy_document.eso_assume.json

  tags = var.tags
}

####################################
# IAM Policy
####################################

resource "aws_iam_policy" "eso" {

  name = "${var.cluster_name}-external-secrets"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid = "ReadSecrets"

        Effect = "Allow"

        Action = [

          "secretsmanager:GetSecretValue",

          "secretsmanager:DescribeSecret",

          "secretsmanager:ListSecrets"

        ]

        Resource = [
          "arn:aws:secretsmanager:${var.region}:*:secret:*"
        ]

      }

    ]

  })

}

####################################
# Attach Policy
####################################

resource "aws_iam_role_policy_attachment" "eso" {

  role = aws_iam_role.eso.name

  policy_arn = aws_iam_policy.eso.arn

}