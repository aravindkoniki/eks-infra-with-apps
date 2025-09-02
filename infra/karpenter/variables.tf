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

variable "subnet_ids" {
  description = "List of subnets where Karpenter should launch nodes (prefer private subnets)"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security groups to attach to instances launched by Karpenter"
  type        = list(string)
  default     = []
}

variable "karpenter_discovery_tag" {
  description = "Tag value Karpenter will use to discover subnets/security groups"
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "Preferred instance types for Karpenter provisioner (comma-separated in manifest templating)"
  type        = list(string)
  default     = ["t3.medium", "t3.large"]
}

variable "ami_family" {
  description = "AMI family for EC2NodeClass (AL2 or Bottlerocket: 'AL2' or 'Bottlerocket')"
  type        = string
  default     = "AL2"
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