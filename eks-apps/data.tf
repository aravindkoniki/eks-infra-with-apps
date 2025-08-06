# Get EKS cluster details
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

# Get authentication token
data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}


data "aws_route53_zone" "main" {
  provider     = aws.MY_NETWORKING
  name         = local.domain_name
  private_zone = false
}

data "aws_elb_service_account" "nlb" {
  provider = aws.MY_NETWORKING
}

# Get NLB hostname from Helm-deployed ingress service
data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "${helm_release.nginx_ingress.name}-controller"
    namespace = var.nginx_ingress_namespace
  }
}
