
# Deploy NGINX ingress controller with AWS NLB
resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = var.nginx_ingress_namespace
  create_namespace = true
  timeout          = 600

  # Service type: NLB
  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  # NLB type
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "\"nlb\""
  }

  # Internet-facing scheme
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "\"internet-facing\""
  }

  # Pass comma-separated subnet IDs as a quoted string
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-subnets"
    value = "\"${join("\\,", var.public_subnet_ids)}\""
    type  = "auto"
  }

  # Optional: Cross-zone load balancing
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
  }
}

resource "kubernetes_manifest" "app_manifests" {
  for_each = { for f in local.manifest_files : f => yamldecode(file("${path.module}/manifests/${f}")) }
  manifest = each.value
}

