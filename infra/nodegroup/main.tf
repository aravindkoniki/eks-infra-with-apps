# IAM Role for Karpenter-managed EC2 nodes
resource "aws_iam_role" "karpenter_node_role" {
  name = "${var.cluster_name}-karpenter-node-role"

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

  tags = {
    Name = "${var.cluster_name}-karpenter-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "karpenter_node" {
  name = "${var.cluster_name}-karpenter-instance-profile"
  role = aws_iam_role.karpenter_node_role.name
}

# Fallback EKS Node Group (minimal, 1 per AZ)
resource "aws_iam_role" "bootstrap_node_role" {
  name = "${var.cluster_name}-bootstrap-node-role"

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

  tags = {
    Name = "${var.cluster_name}-bootstrap-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "bootstrap_node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
  role       = aws_iam_role.bootstrap_node_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "bootstrap" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.bootstrap_node_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = length(var.private_subnet_ids)
    min_size     = length(var.private_subnet_ids)
    max_size     = length(var.private_subnet_ids) + 2
  }

  instance_types = var.instance_types
  disk_size      = 20
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  version        = var.eks_version

  tags = {
    Name                                        = var.node_group_name
    "karpenter.sh/discovery"                    = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
