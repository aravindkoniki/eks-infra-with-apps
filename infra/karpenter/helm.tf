resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}

data "template_file" "karpenter_controller" {
  template = file("${path.module}/manifests/templates/karpenter-controller.tpl.yaml")
  vars = {
    cluster_name                    = var.cluster_name
    cluster_endpoint                = data.aws_eks_cluster.cluster.endpoint
    irsa_role_arn                   = aws_iam_role.karpenter_controller.arn
    karpenter_node_instance_profile = aws_iam_instance_profile.karpenter_node_profile.name
    karpenter_version               = var.karpenter_version
    # ...add other variables as needed...
  }
}

resource "kubernetes_manifest" "karpenter_controller" {
  manifest   = yamldecode(data.template_file.karpenter_controller.rendered)
  depends_on = [kubernetes_namespace.karpenter]
}