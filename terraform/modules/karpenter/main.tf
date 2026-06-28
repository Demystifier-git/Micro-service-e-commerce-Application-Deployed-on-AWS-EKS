resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = var.namespace

  create_namespace = true

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  # ✅ FIX: correct key for your chart version
  set {
    name  = "clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.iam_role_arn
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = var.instance_profile
  }

  timeout       = 600
  force_update  = true
  recreate_pods = true
}