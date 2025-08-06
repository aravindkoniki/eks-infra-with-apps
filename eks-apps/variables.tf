# variable "kubeconfig_path" {
#   description = "Path to kubeconfig file for cluster access"
#   type        = string
#   default     = "~/.kube/config"
# }

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the NLB"
  type        = list(string)
  default     = ["subnet-0e6b49e2693b25ea4", "subnet-05a4ea83a4bfdc422", "subnet-08c0d938a22d19708"] # Example values, replace with actual subnet IDs
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "private-eks"
}

variable "region" {
  description = "The AWS region to deploy the infrastructure"
  default     = "eu-west-1"
}

variable "nginx_ingress_namespace" {
  description = "Namespace for the NGINX ingress controller"
  type        = string
  default     = "ingress-nginx"

}
