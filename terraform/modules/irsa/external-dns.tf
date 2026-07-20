####################################
# ExternalDNS Trust Policy
####################################

data "aws_iam_policy_document" "external_dns_assume" {

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
        "system:serviceaccount:kube-system:external-dns"
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

resource "aws_iam_role" "external_dns" {

  name = "${var.cluster_name}-external-dns"

  assume_role_policy = data.aws_iam_policy_document.external_dns_assume.json

  tags = var.tags
}

####################################
# IAM Policy
####################################

resource "aws_iam_policy" "external_dns" {

  name = "${var.cluster_name}-external-dns"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid = "Route53Change"

        Effect = "Allow"

        Action = [
          "route53:ChangeResourceRecordSets"
        ]

        Resource = [
          "arn:aws:route53:::hostedzone/*"
        ]
      },

      {

        Sid = "Route53Read"

        Effect = "Allow"

        Action = [

          "route53:ListHostedZones",

          "route53:ListHostedZonesByName",

          "route53:ListResourceRecordSets",

          "route53:GetHostedZone"

        ]

        Resource = "*"

      }

    ]

  })
}


# Attach Policy


resource "aws_iam_role_policy_attachment" "external_dns" {

  role = aws_iam_role.external_dns.name

  policy_arn = aws_iam_policy.external_dns.arn
}