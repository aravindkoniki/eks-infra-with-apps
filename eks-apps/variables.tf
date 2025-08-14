# variable "kubeconfig_path" {
#   description = "Path to kubeconfig file for cluster access"
#   type        = string
#   default     = "~/.kube/config"
# }

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the NLB"
  type        = list(string)
  default     = ["subnet-08c2a5b60584f20f8", "subnet-0e172375aeb669ace", "subnet-0a4d43fc4e228b166"] # Example values, replace with actual subnet IDs
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
