locals {
  discovery_tag_key   = "karpenter.sh/discovery"
  discovery_tag_value = length(var.karpenter_discovery_tag) > 0 ? var.karpenter_discovery_tag : var.cluster_name
}

resource "kubernetes_manifest" "ec2nodeclass" {
  manifest = {
    apiVersion = "karpenter.k8s.aws/v1beta1"
    kind       = "EC2NodeClass"
    metadata = {
      name = "karpenter-ec2-default"
    }
    spec = {
      amiFamily = var.ami_family
      subnetSelectorTerms = (
        length(var.subnet_ids) > 0 ?
        [
          {
            ids = var.subnet_ids
          }
        ] :
        [
          {
            tags = {
              "${local.discovery_tag_key}" = local.discovery_tag_value
            }
          }
        ]
      )
      securityGroupSelectorTerms = (
        length(var.security_group_ids) > 0 ?
        [
          {
            ids = var.security_group_ids
          }
        ] :
        [
          {
            tags = {
              "kubernetes.io/cluster/${var.cluster_name}" = "owned"
            }
          }
        ]
      )
      metadataOptions = {
        httpEndpoint = "enabled"
        httpTokens   = "required"
      }
      tags = {
        "karpenter.sh/discovery" = local.discovery_tag_value
      }
    }
  }
  depends_on = [helm_release.karpenter]
}

resource "kubernetes_manifest" "provisioner" {
  manifest = {
    apiVersion = "karpenter.sh/v1alpha5"
    kind       = "Provisioner"
    metadata = {
      name = "default"
    }
    spec = {
      constraints = {
        labels = {
          "karpenter.sh/provisioner-name" = "default"
        }
      }
      provider = {
        instanceProfile = aws_iam_instance_profile.karpenter_node_profile.name
      }
      requirements = [
        {
          key      = "kubernetes.io/arch"
          operator = "In"
          values   = ["amd64"]
        },
        {
          key      = "node.kubernetes.io/instance-type"
          operator = "In"
          values   = var.instance_types
        }
      ]
      limits = {
        resources = {
          cpu = "2000"
        }
      }
      ttlSecondsAfterEmpty = 300
      consolidation = {
        enabled = true
      }
    }
  }
  depends_on = [helm_release.karpenter, kubernetes_manifest.ec2nodeclass]
}