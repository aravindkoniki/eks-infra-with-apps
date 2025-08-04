variable "cluster_name" {
  description = "name of the EKS cluster"
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "region" {
  description = "value of the AWS region where the EKS cluster is deployed"
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

variable "ami_type" {
  description = "AMI type for the EKS node group"
  default     = "AL2_x86_64"
}