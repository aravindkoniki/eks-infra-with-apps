resource "aws_eks_addon" "coredns" {
  provider                    = aws.MY_NETWORKING
  cluster_name                = data.aws_eks_cluster.this.name
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                  = [module.eks_node_group]
}

resource "aws_eks_addon" "kube-proxy" {
  provider                    = aws.MY_NETWORKING
  cluster_name                = data.aws_eks_cluster.this.name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "vpc-cni" {
  provider                    = aws.MY_NETWORKING
  cluster_name                = data.aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_update = "OVERWRITE"
}
