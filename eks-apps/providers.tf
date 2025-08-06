## run the below command to update kubeconfig
## aws eks update-kubeconfig --region <region> --name <cluster_name> --profile <aws_profile>

# provider "helm" {
#   kubernetes {
#     config_path = var.kubeconfig_path
#   }
# }

# provider "kubernetes" {
#   config_path = var.kubeconfig_path
# }


## dynamic provider configuration for EKS cluster to avoid running `aws eks update-kubeconfig` command
# Kubernetes Provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Helm Provider
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}