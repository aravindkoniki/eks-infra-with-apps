variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "node_group_name" {
  description = "EKS Node Group name"
  type        = string
  default     = "eks-ng"
}

variable "eks_version" {
  description = "Kubernetes version for the node group"
  type        = string
}

variable "instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 6
}

variable "ami_type" {
  description = "AMI type for the node group"
  type        = string
  default     = "AL2_x86_64"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string

}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
