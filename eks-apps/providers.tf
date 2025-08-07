## run the below command to update kubeconfig
## aws eks update-kubeconfig --name private-eks --region eu-west-1 --profile MY_NETWORKING

# provider "helm" {
#   kubernetes {
#     config_path = var.kubeconfig_path
#   }
# }

# provider "kubernetes" {
#   config_path = var.kubeconfig_path
# }


## dynamic provider configuration for EKS cluster to avoid running `aws eks update-kubeconfig` command
# Helm Provider (uses same auth as Kubernetes)


# Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Helm provider (v2+)
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "aws" {
  region  = var.region
  profile = "MY_NETWORKING"
  alias   = "MY_NETWORKING"
}