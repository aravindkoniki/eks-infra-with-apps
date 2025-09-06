resource "kubernetes_manifest" "provisioner" {
  manifest = yamldecode(templatefile("${path.module}/provisioner.tpl.yaml", {
    # add your variables here
  }))
  depends_on = [module.karpenter_helm]
}

resource "kubernetes_manifest" "ec2nodeclass" {
  manifest = yamldecode(templatefile("${path.module}/ec2nodeclass.tpl.yaml", {
    # add your variables here
  }))
  depends_on = [module.karpenter_helm]
}
