variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for cluster (for IRSA assume role)"
  type        = string
}


variable "karpenter_version" {
  description = "Karpenter Helm chart version (or chart tag)"
  type        = string
  default     = "v0.33.0" # adjust as needed
}

variable "tags" {
  description = "Tags to attach to IAM roles / instance profile"
  type        = map(string)
  default     = {}
}