variable "cluster_name" { type = string }
variable "cluster_endpoint" { type = string }
variable "irsa_role_arn" { type = string }
variable "karpenter_node_instance_profile" { type = string }
variable "karpenter_version" {
  type    = string
  default = "v0.33.0"
}

variable "tags" {
  description = "Tags to attach to IAM roles / instance profile"
  type        = map(string)
  default     = {}
}