variable "cluster_name" {
  description = "The name of the EKS cluster"
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "region" {
  description = "The AWS region to deploy the EKS cluster"
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  default     = "1.29"
}