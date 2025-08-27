output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "node_security_group_id" {
  value = data.aws_security_group.eks_node_sg.id
}
