variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for cluster (for IRSA assume role)"
  type        = string
}


variable "tags" {
  description = "Tags to attach to IAM roles / instance profile"
  type        = map(string)
  default     = {}
}
