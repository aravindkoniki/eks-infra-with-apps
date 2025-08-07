
# Deploy NGINX ingress controller with AWS NLB

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = var.nginx_ingress_namespace
  create_namespace = true

  values = [
    templatefile("${path.module}/manifests/nginx/nginx-values.tpl.yaml", {
      subnet_ids = join(",", var.public_subnet_ids)
    })
  ]
  timeout = 600
}

resource "kubernetes_manifest" "app_manifests" {
  for_each = { for f in local.manifest_files : f => yamldecode(file("${path.module}/manifests/${f}")) }
  manifest = each.value
}

