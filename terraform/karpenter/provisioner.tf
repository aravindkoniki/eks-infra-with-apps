resource "kubernetes_manifest" "karpenter_provisioner" {
  manifest = {
    apiVersion = "karpenter.sh/v1alpha5"
    kind       = "Provisioner"
    metadata = {
      name = var.provisioner_name
    }
    spec = {
      requirements = [
        {
          key      = "node.kubernetes.io/instance-type"
          operator = "In"
          values   = var.instance_types
        },
        {
          key      = "topology.kubernetes.io/zone"
          operator = "In"
          values   = var.availability_zones
        }
      ]
      limits = {
        resources = {
          cpu    = "1000"
          memory = "1000Gi"
        }
      }
      provider = {
        subnetSelector = {
          "karpenter.sh/discovery" = var.cluster_name
        }
        securityGroupSelector = {
          "karpenter.sh/discovery" = var.cluster_name
        }
      }
      ttlSecondsAfterEmpty = 30
    }
  }
}