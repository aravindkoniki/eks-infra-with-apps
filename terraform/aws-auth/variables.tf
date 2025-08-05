variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_certificate_authority" {
  description = "EKS cluster certificate authority data"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the EKS node group role"
  type        = string
}

variable "token" {
  description = "Token for authenticating with the EKS cluster"
  type        = string
}