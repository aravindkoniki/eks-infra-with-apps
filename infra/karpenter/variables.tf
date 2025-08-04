
variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "kubeconfig_path" {}
variable "instance_profile" {}
variable "provisioner_name" {
  default = "default"
}
variable "instance_types" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}

variable "oidc_provider_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}
