data "aws_eks_cluster" "this" {
  provider   = aws.MY_NETWORKING
  name       = module.eks_control_plane.cluster_name
  depends_on = [module.eks_control_plane]
}

data "aws_eks_cluster_auth" "this" {
  provider   = aws.MY_NETWORKING
  name       = module.eks_control_plane.cluster_name
  depends_on = [module.eks_control_plane]
}


data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}


# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  provider    = aws.MY_NETWORKING
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
