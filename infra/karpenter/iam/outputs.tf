output "karpenter_controller_role_arn" {
  value       = aws_iam_role.karpenter_controller.arn
  description = "ARN of the Karpenter controller IAM role."
}

output "karpenter_node_role_arn" {
  value       = aws_iam_role.karpenter_node.arn
  description = "ARN of the Karpenter node IAM role."
}

output "karpenter_node_instance_profile" {
  value       = aws_iam_instance_profile.karpenter_node_profile.name
  description = "Name of the Karpenter node instance profile."
}