locals {
  discovery_tag_key   = "karpenter.sh/discovery"
  discovery_tag_value = length(var.karpenter_discovery_tag) > 0 ? var.karpenter_discovery_tag : var.cluster_name
}


# render EC2NodeClass
data "template_file" "ec2nodeclass" {
  template = file("${path.module}/manifests/ec2nodeclass.tpl.yaml")
  vars = {
    amiFamily           = var.ami_family
    subnetIds           = var.subnet_ids
    securityGroupIds    = var.security_group_ids
    clusterName         = var.cluster_name
    discoveryTagKey     = local.discovery_tag_key
    discoveryTagValue   = local.discovery_tag_value
  }
}

resource "kubernetes_manifest" "ec2nodeclass" {
  manifest   = yamldecode(data.template_file.ec2nodeclass.rendered)
  # Wait until controller exists
  depends_on = [helm_release.karpenter]
}

# render Provisioner
data "template_file" "provisioner" {
  template = file("${path.module}/manifests/provisioner.tpl.yaml")
  vars = {
    karpenterNodeInstanceProfile = aws_iam_instance_profile.karpenter_node_profile.name
    instanceTypes                = var.instance_types
  }
}

resource "kubernetes_manifest" "provisioner" {
  manifest   = yamldecode(data.template_file.provisioner.rendered)
  depends_on = [helm_release.karpenter, kubernetes_manifest.ec2nodeclass]
}