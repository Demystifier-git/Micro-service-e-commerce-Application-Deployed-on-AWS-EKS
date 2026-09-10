resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::245361884126:role/ec2-role"
        username = "ec2-role"
        groups   = ["eks-readers"]
      }
    ])
  }
}