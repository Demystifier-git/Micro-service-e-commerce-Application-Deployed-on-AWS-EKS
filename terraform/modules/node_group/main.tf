# ----------------------------
# NODE GROUPS (ON-DEMAND + SPOT)
# ----------------------------

resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = var.cluster_name
  node_group_name = each.value.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  scaling_config {
    desired_size = each.value.desired_capacity
    min_size     = each.value.min_capacity
    max_size     = each.value.max_capacity
  }





  tags = var.tags
}