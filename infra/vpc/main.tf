data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge({
    Name = "${var.name}-vpc"
  }, var.tags)
}

# Private subnets (for EKS control plane & worker nodes)
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(var.private_subnet_tags, {
    Name = "${var.name}-private-${count.index + 1}"
  }, var.tags)
}

# Public subnets (for NAT Gateways only)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.public_subnet_tags, {
    Name = "${var.name}-public-${count.index + 1}"
  }, var.tags)
}

# Internet Gateway for NAT reachability
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge({
    Name = "${var.name}-igw"
  }, var.tags)
}

# EIPs for NAT Gateways
resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
  tags   = var.tags
}

# NAT Gateways
resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = merge({
    Name = "${var.name}-nat-${count.index + 1}"
  }, var.tags)
}

# Public route table & associations
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge({
    Name = "${var.name}-public-rt"
  }, var.tags)
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route tables & associations (via NAT)
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  tags = merge({
    Name = "${var.name}-private-rt-${count.index + 1}"
  }, var.tags)
}

resource "aws_route" "private_nat_gateway" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
