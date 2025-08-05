module "vpc" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source = "./vpc"
  name   = var.name
  region = var.region
  subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "shared",
    "kubernetes.io/role/internal-elb"   = "1"
  }
}

module "eks_control_plane" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source             = "./eks"
  cluster_name       = var.name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_version        = var.eks_version
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
}

# # this cant be run while on a fully private cluster
# # cluster API endpoint is not accessible
# module "aws_auth" {
#   source                        = "./aws-auth"
#   cluster_endpoint              = module.eks_control_plane.cluster_endpoint
#   cluster_certificate_authority = module.eks_control_plane.cluster_certificate_authority
#   token                         = data.aws_eks_cluster_auth.this.token
#   node_role_arn                 = module.eks_node_group.node_role_arn
#   depends_on                    = [module.eks_node_group]
# }
