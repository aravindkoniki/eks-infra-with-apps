# variable "kubeconfig_path" {
#   description = "Path to kubeconfig file for cluster access"
#   type        = string
#   default     = "~/.kube/config"
# }

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the NLB"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}