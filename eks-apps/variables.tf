# variable "kubeconfig_path" {
#   description = "Path to kubeconfig file for cluster access"
#   type        = string
#   default     = "~/.kube/config"
# }

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
