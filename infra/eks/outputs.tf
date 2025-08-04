output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_security_group_id" {
  value = aws_security_group.eks_cluster_sg.id
}