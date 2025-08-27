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

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    "Terraform"   = "true"
    "Environment" = "dev"
  }
}

# Variable to define the list of repositories to create
variable "ecr_repositories" {
  description = "List of ECR repository configurations"
  type = list(object({
    name                 = string
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, true)
    lifecycle_policy     = optional(string, null)
  }))
  default = [
    {
      name                 = "ui-app1"
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
    },
    {
      name                 = "ui-app2"
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
    }
  ]
}
