# resource "aws_eks_addon" "coredns" {
#   provider                    = aws.MY_NETWORKING
#   cluster_name                = data.aws_eks_cluster.eks.name
#   addon_name                  = "coredns"
#   resolve_conflicts_on_update = "OVERWRITE"
# }

# resource "aws_eks_addon" "kube-proxy" {
#   provider                    = aws.MY_NETWORKING
#   cluster_name                = data.aws_eks_cluster.eks.name
#   addon_name                  = "kube-proxy"
#   resolve_conflicts_on_update = "OVERWRITE"
# }

# resource "aws_eks_addon" "vpc-cni" {
#   provider                    = aws.MY_NETWORKING
#   cluster_name                = data.aws_eks_cluster.eks.name
#   addon_name                  = "vpc-cni"
#   resolve_conflicts_on_update = "OVERWRITE"
#   depends_on                  = [module.eks_node]
# }
