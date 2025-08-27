resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}

# Install Karpenter via Helm (OCI registry)
resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter/karpenter"
  chart      = "karpenter"
  version    = var.karpenter_version
  namespace  = kubernetes_namespace.karpenter.metadata[0].name
  create_namespace = false
  wait = true
  timeout = 600

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = data.aws_eks_cluster.cluster.endpoint
  }

  # bind IRSA role to controller service account (karpenter in karpenter namespace)
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }

  # Use instance profile name for node creation (Karpenter will use iam:PassRole to associate)
  set {
    name  = "controller.extraArgs"
    value = "--instance-profile=${aws_iam_instance_profile.karpenter_node_profile.name}"
  }
}