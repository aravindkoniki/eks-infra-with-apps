output "karpenter_node_group_name" {
  value = aws_eks_node_group.worker_node.node_group_name
}

output "karpenter_node_group_role_arn" {
  value = aws_iam_role.worker_node_role.arn
}