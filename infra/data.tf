data "aws_eks_cluster" "eks" {
  name = var.name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.name
}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
