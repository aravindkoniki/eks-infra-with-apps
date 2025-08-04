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
  source = "./eks"
  cluster_name        = var.name
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  region              = var.region
}