output "karpenter_helm_release" {
  value = helm_release.karpenter.name
}

output "karpenter_provisioner_name" {
  value = kubernetes_manifest.karpenter_provisioner.manifest["metadata"]["name"]
}
