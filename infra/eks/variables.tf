variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (one in each AZ)"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
}
