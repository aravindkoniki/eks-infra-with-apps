variable "region" {
  description = "The AWS region to deploy the infrastructure"
}

variable "name" {
  description = "The name of the infrastructure"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets (one per AZ)"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets (for NAT Gateways)"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnet_tags" {
  description = "Tags to apply to the subnets"
  type        = map(string)
}

variable "public_subnet_tags" {
  description = "Tags to apply to the subnets"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
