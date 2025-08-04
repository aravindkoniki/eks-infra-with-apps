variable "cluster_name" {
  description = "name of the EKS cluster"
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "node_group_name" {
  description = "name of the EKS node group"
}

variable "eks_version" {
  description = "The version of the EKS cluster"
}

variable "instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}
