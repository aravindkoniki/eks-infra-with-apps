# variable "kubeconfig_path" {
#   description = "Path to kubeconfig file for cluster access"
#   type        = string
#   default     = "~/.kube/config"
# }

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the NLB"
  type        = list(string)
  default     = ["subnet-06b7cb8d2b9c9b336", "subnet-029148b710459cc57", "subnet-0a1c71a1c3b5ccde9"] # Example values, replace with actual subnet IDs
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
