module "vpc" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source = "./vpc"
  name   = var.name
  region = var.region
}

module "eks_control_plane" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source             = "./eks"
  cluster_name       = var.name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  region             = var.region
  eks_version        = var.eks_version
}

module "eks_node" {
  providers = {
    aws = aws.MY_NETWORKING
  }
  source             = "./nodegroup"
  node_group_name    = "${var.name}-node-group"
  cluster_name       = var.name
  private_subnet_ids = module.vpc.private_subnet_ids
  region             = var.region
  eks_version        = var.eks_version
  instance_types     = ["t3.medium"]
  ami_type           = "AL2_x86_64"
}
