variable "region" {
  description = "The AWS region to deploy the infrastructure"
  default     = "eu-west-1"
}

variable "name" {
  description = "The name of the infrastructure"
  default     = "private-eks"
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  default     = "1.32"
}

variable "endpoint_public_access" {
  description = "Enable public access to the EKS cluster endpoint"
  type        = bool
  default     = true
}