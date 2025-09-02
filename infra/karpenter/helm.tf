resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = kubernetes_namespace.karpenter.metadata[0].name
  version    = var.karpenter_version
  values = [
    templatefile("${path.module}/manifests/karpenter-values.tpl.yaml", {
      cluster_name                    = var.cluster_name
      cluster_endpoint                = data.aws_eks_cluster.cluster.endpoint
      irsa_role_arn                   = aws_iam_role.karpenter_controller.arn
      karpenter_node_instance_profile = aws_iam_instance_profile.karpenter_node_profile.name
    })
  ]
  depends_on = [kubernetes_namespace.karpenter]
}

resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}