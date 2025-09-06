
resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = kubernetes_namespace.karpenter.metadata[0].name
  version    = var.karpenter_version
  values = [templatefile("${path.module}/karpenter-values.tpl.yaml", {
    cluster_name                    = var.cluster_name
    cluster_endpoint                = var.cluster_endpoint
    irsa_role_arn                   = var.irsa_role_arn
    karpenter_node_instance_profile = var.karpenter_node_instance_profile
  })]
  depends_on = [kubernetes_namespace.karpenter]
}
