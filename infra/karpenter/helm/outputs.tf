output "namespace" {
  value = kubernetes_namespace.karpenter.metadata[0].name
}

output "helm_release_name" {
  value = helm_release.karpenter.name
}

output "service_account_annotation" {
  value       = helm_release.karpenter.set[0].value
  description = "The service account annotation used for IRSA."
}