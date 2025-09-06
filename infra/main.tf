module "vpc" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source = "./vpc"
  name   = var.name
  region = var.region
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.name}"  = "owned"
    "kubernetes.io/role/internal-elb"    = "1"
    "karpenter.sh/discovery/${var.name}" = "${var.name}"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "owned"
    "kubernetes.io/role/elb"            = "1"
  }
  tags = var.tags
}

module "eks_control_plane" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source                  = "./eks"
  cluster_name            = var.name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  eks_version             = var.eks_version
  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = false
  tags                    = var.tags
}

module "eks_node_group" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source             = "./nodegroup"
  cluster_name       = module.eks_control_plane.cluster_name
  eks_version        = var.eks_version
  private_subnet_ids = module.vpc.private_subnet_ids
  desired_size       = 3
  min_size           = 3
  max_size           = 6
  instance_types     = ["t3.medium"]
  vpc_id             = module.vpc.vpc_id
  tags               = var.tags
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = module.eks_node_group.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      },
      {
        rolearn  = module.eks_control_plane.cluster_role_arn
        username = "admin"
        groups   = ["system:masters"]
      }
    ])
  }
}

# module "karpenter" {
#   providers = {
#     aws = aws.MY_NETWORKING
#   }
#   source            = "./karpenter"
#   region            = var.region
#   cluster_name      = var.name
#   oidc_provider_arn = module.eks_control_plane.oidc_provider_arn
#   tags              = var.tags
# }

module "karpenter_iam" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source            = "./karpenter/iam"
  cluster_name      = var.name
  oidc_provider_arn = module.eks_control_plane.oidc_provider_arn
  tags              = var.tags
}

module "karpenter_helm" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source                          = "./karpenter/controller"
  cluster_name                    = var.name
  cluster_endpoint                = module.eks_control_plane.cluster_endpoint
  irsa_role_arn                   = module.karpenter_iam.karpenter_controller_role_arn
  karpenter_node_instance_profile = module.karpenter_iam.karpenter_node_instance_profile_name
  depends_on                      = [module.karpenter_iam]
}
