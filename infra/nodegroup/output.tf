output "karpenter_node_group_name" {
  value = aws_eks_node_group.karpenter_bootstrap.node_group_name
}

output "karpenter_node_group_role_arn" {
  value = aws_iam_role.node_group_role.arn
}