locals {
  discovery_tag_key   = "karpenter.sh/discovery"
  discovery_tag_value = length(var.karpenter_discovery_tag) > 0 ? var.karpenter_discovery_tag : var.cluster_name
}


# render EC2NodeClass
data "template_file" "ec2nodeclass" {
  template = file("${path.module}/manifests/templates/ec2nodeclass.tpl.yaml")
  vars = {
    ami_family          = var.ami_family
    subnet_ids          = var.subnet_ids
    security_group_ids  = var.security_group_ids
    cluster_name        = var.cluster_name
    discovery_tag_key   = local.discovery_tag_key
    discovery_tag_value = local.discovery_tag_value
  }
}

resource "kubernetes_manifest" "ec2nodeclass" {
  manifest = yamldecode(data.template_file.ec2nodeclass.rendered)
  # Wait until controller exists
  depends_on = [helm_release.karpenter]
}

# render Provisioner
data "template_file" "provisioner" {
  template = file("${path.module}/manifests/templates/provisioner.tpl.yaml")
  vars = {
    karpenter_node_instance_profile = aws_iam_instance_profile.karpenter_node_profile.name
    instance_types                  = var.instance_types
  }
}

resource "kubernetes_manifest" "provisioner" {
  manifest = yamldecode(data.template_file.provisioner.rendered)
  depends_on = [helm_release.karpenter, kubernetes_manifest.ec2nodeclass]
}