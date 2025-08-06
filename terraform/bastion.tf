# IAM Role for Bastion
resource "aws_iam_role" "bastion_role" {
  count    = var.endpoint_public_access == false ? 1 : 0
  provider = aws.MY_NETWORKING
  name     = "bastion-eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach EKS Admin permissions
resource "aws_iam_role_policy_attachment" "full_access" {
  count      = var.endpoint_public_access == false ? 1 : 0
  provider   = aws.MY_NETWORKING
  role       = aws_iam_role.bastion_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Instance Profile
resource "aws_iam_instance_profile" "bastion_profile" {
  count    = var.endpoint_public_access == false ? 1 : 0
  provider = aws.MY_NETWORKING
  name     = "bastion-eks-admin-profile"
  role     = aws_iam_role.bastion_role[0].name
}

# Security group for SSH access
resource "aws_security_group" "bastion_sg" {
  count       = var.endpoint_public_access == false ? 1 : 0
  provider    = aws.MY_NETWORKING
  name        = "bastion-sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For tighter security, restrict to your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Bastion EC2 instance
resource "aws_instance" "bastion" {
  count                       = var.endpoint_public_access == false ? 1 : 0
  provider                    = aws.MY_NETWORKING
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile[0].name
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg[0].id]
  key_name                    = "networking-account-keypair-iteland-01"
  associate_public_ip_address = true
  tags = {
    Name = "bastion-host"
  }
}
