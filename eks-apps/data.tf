# Get EKS cluster details
data "aws_eks_cluster" "this" {
  provider = aws.MY_NETWORKING
  name     = var.cluster_name
}

# Get authentication token
data "aws_eks_cluster_auth" "this" {
  provider = aws.MY_NETWORKING
  name     = var.cluster_name
}


data "aws_route53_zone" "main" {
  provider     = aws.MY_NETWORKING
  name         = local.domain_name
  private_zone = false
}

# Get NLB hostname from Helm-deployed ingress service
data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "${helm_release.nginx_ingress.name}-controller"
    namespace = var.nginx_ingress_namespace
  }
}

data "aws_lb" "nlb" {
  provider = aws.MY_NETWORKING
  name     = regex("^[^-]+", data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname)
}

data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../infra/terraform.tfstate"
  }
}