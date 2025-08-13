output "node_role_arn" {
  value = module.eks_node_group.node_role_arn
}

output "bastion_public_ip" {
  value = var.endpoint_public_access == false ? aws_instance.bastion[0].public_ip : null
}

output "vpc_endpoints" {
  description = "VPC Endpoints for private ECR and S3 access"
  value = {
    ecr_api = aws_vpc_endpoint.ecr_api.id
    ecr_dkr = aws_vpc_endpoint.ecr_dkr.id
    s3      = aws_vpc_endpoint.s3.id
    logs    = aws_vpc_endpoint.logs.id
    sts     = aws_vpc_endpoint.sts.id
  }
}

output "vpc_endpoints_dns_entries" {
  description = "DNS entries for VPC endpoints"
  value = {
    ecr_api = aws_vpc_endpoint.ecr_api.dns_entry
    ecr_dkr = aws_vpc_endpoint.ecr_dkr.dns_entry
    logs    = aws_vpc_endpoint.logs.dns_entry
    sts     = aws_vpc_endpoint.sts.dns_entry
  }
}
 
output "vpc_endpoints_security_group_id" {
  description = "Security group ID for VPC endpoints"
  value       = aws_security_group.vpc_endpoints.id
}
