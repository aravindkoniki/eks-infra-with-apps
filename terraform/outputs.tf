output "node_role_arn" {
  value = module.eks_node_group.node_role_arn
}

output "bastion_public_ip" {
  value = var.endpoint_public_access == false ? aws_instance.bastion[0].public_ip : null
}
