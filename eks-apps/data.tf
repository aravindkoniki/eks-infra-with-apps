# Get EKS cluster details
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

# Get authentication token
data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}