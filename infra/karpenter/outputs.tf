output "karpenter_controller_role_arn" {
  value = aws_iam_role.karpenter_controller.arn
}

output "karpenter_node_instance_profile" {
  value = aws_iam_instance_profile.karpenter_node_profile.name
}

output "karpenter_node_role_name" {
  value = aws_iam_role.karpenter_node.name
}