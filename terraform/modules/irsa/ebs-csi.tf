####################################
# EBS CSI Driver Trust Policy
####################################

data "aws_iam_policy_document" "ebs_csi_assume" {

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
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
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

resource "aws_iam_role" "ebs_csi" {

  name = "${var.cluster_name}-ebs-csi"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume.json

  tags = var.tags
}

####################################
# AWS Managed Policy
####################################

resource "aws_iam_role_policy_attachment" "ebs_csi" {

  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}