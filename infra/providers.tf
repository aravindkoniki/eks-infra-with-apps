provider "aws" {
  region  = var.region
  profile = "MY_NETWORKING"
  alias   = "MY_NETWORKING"
}

provider "aws" {
  region  = var.region
  profile = "MY_DEV_ENVIRONMENT"
  alias   = "MY_DEV_ENVIRONMENT"
}

provider "kubernetes" {
  host                   = module.eks_control_plane.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_control_plane.cluster_certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
}
