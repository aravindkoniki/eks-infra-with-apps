# VPC Endpoints for ECR and S3 access
# This allows EKS nodes to pull container images from ECR without internet access

# Security group for VPC endpoints
resource "aws_security_group" "vpc_endpoints" {
  provider    = aws.MY_NETWORKING
  name        = "${var.name}-vpc-endpoints"
  description = "Security group for VPC endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.name}-vpc-endpoints"
  }, var.tags)
}

# Interface VPC Endpoint for ECR API (control plane)
resource "aws_vpc_endpoint" "ecr_api" {
  provider            = aws.MY_NETWORKING
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge({
    Name = "${var.name}-ecr-api-endpoint"
  }, var.tags)
}

# Interface VPC Endpoint for ECR DKR (data plane - image layers)
resource "aws_vpc_endpoint" "ecr_dkr" {
  provider            = aws.MY_NETWORKING
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge({
    Name = "${var.name}-ecr-dkr-endpoint"
  }, var.tags)
}

# Interface VPC Endpoint for S3 with custom configuration
resource "aws_vpc_endpoint" "s3_interface" {
  provider            = aws.MY_NETWORKING
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = false

  tags = merge({
    Name = "${var.name}-s3-interface-endpoint"
  }, var.tags)
}

# Gateway VPC Endpoint for S3 (ECR stores image layers in S3)
resource "aws_vpc_endpoint" "s3" {
  provider          = aws.MY_NETWORKING
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids

  tags = merge({
    Name = "${var.name}-s3-endpoint"
  }, var.tags)
}

# Optional: VPC Endpoint for CloudWatch Logs (if you want to send logs without internet)
resource "aws_vpc_endpoint" "logs" {
  provider            = aws.MY_NETWORKING
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true


  tags = merge({
    Name = "${var.name}-logs-endpoint"
  }, var.tags)

}

# Optional: VPC Endpoint for STS (Security Token Service)
resource "aws_vpc_endpoint" "sts" {
  provider            = aws.MY_NETWORKING
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge({
    Name = "${var.name}-sts-endpoint"
  }, var.tags)
}
