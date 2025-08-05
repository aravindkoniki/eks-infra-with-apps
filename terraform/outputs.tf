output "node_role_arn" {
  value = module.eks_node_group.node_role_arn
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}