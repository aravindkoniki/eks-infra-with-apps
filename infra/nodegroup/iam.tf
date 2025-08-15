# IAM Role for Nodes
resource "aws_iam_role" "node_role" {
  name = "${var.cluster_name}-${var.node_group_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  tags = merge({
    Name = "${var.cluster_name}-${var.node_group_name}-role"
  }, var.tags)
}

# Custom IAM policy for ECR access with additional permissions
resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.cluster_name}-${var.node_group_name}-ecr-policy"
  description = "IAM policy for EKS nodes to access ECR repositories"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:DescribeImages",
          "ecr:ListImages"
        ]
        Resource = ["*"]
      }
    ]
  })

  tags = merge({
    Name = "${var.cluster_name}-${var.node_group_name}-ecr-policy"
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.node_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

# Add data source for current AWS account
data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  role       = aws_iam_role.node_role.name
  policy_arn = each.value
}
