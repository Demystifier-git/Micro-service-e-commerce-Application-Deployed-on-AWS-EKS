####################################
# ALB Controller Trust Policy
####################################

locals {
  oidc_host = replace(var.oidc_provider_url, "https://", "")
}

data "aws_iam_policy_document" "alb_assume" {

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
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
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

resource "aws_iam_role" "alb" {

  name = "${var.cluster_name}-alb-controller"

  assume_role_policy = data.aws_iam_policy_document.alb_assume.json

  tags = var.tags
}

####################################
# AWS Managed Policy
####################################

resource "aws_iam_policy" "alb" {

  name = "${var.cluster_name}-alb-controller"

  policy = file("${path.module}/policies/aws-load-balancer-controller.json")
}

resource "aws_iam_role_policy_attachment" "alb" {

  role = aws_iam_role.alb.name

  policy_arn = aws_iam_policy.alb.arn
}