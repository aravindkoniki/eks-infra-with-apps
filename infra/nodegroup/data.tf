# Retrieve default EKS AMI
# Replace with custom filter if needed
data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS official

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
