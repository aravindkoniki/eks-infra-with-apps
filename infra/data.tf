data "aws_eks_cluster" "eks" {
  provider   = aws.MY_NETWORKING
  name       = var.name
  depends_on = [module.eks_control_plane]
}

data "aws_eks_cluster_auth" "eks" {
  provider   = aws.MY_NETWORKING
  name       = var.name
  depends_on = [module.eks_control_plane]
}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
