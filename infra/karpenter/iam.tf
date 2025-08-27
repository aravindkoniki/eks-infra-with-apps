locals {
  svc_account_sub = "karpenter"
  svc_account_name = "karpenter"
  karpenter_sa_full = "${locals.svc_account_sub}:${locals.svc_account_name}"
  discovery_tag_key = "karpenter.sh/discovery"
}

# IRSA assume role policy
data "aws_iam_policy_document" "karpenter_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = replace(var.oidc_provider_arn, "/oidc-provider/", "") + ":sub"
      # allow only the karpenter service account in the karpenter namespace
      values = ["system:serviceaccount:karpenter:karpenter"]
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {
  name               = "${var.cluster_name}-karpenter-controller"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json
  tags               = merge({"Name" = "${var.cluster_name}-karpenter-controller"}, var.tags)
}

# Controller policy (minimal set taken from Karpenter docs; tailor as needed)
data "aws_iam_policy_document" "karpenter_controller_policy" {
  statement {
    sid = "KarpenterEC2Permissions"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeImages",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:CreateLaunchTemplate",
      "ec2:DeleteLaunchTemplate",
      "ec2:ModifyInstanceAttribute",
      "ec2:DescribeAvailabilityZones",
      "ec2:CreateFleet",
      "ec2:CancelSpotInstanceRequests",
      "ec2:DescribeSpotInstanceRequests",
      "iam:PassRole",
      "ssm:GetParameters",
      "pricing:GetProducts",
      "ec2:DescribeInstanceTypes",
      "eks:DescribeNodegroup"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name   = "${var.cluster_name}-karpenter-controller-policy"
  policy = data.aws_iam_policy_document.karpenter_controller_policy.json
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}

# Node Role for instances launched by Karpenter
resource "aws_iam_role" "karpenter_node" {
  name = "${var.cluster_name}-karpenter-node"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  tags = merge({"Name" = "${var.cluster_name}-karpenter-node"}, var.tags)
}

resource "aws_iam_role_policy_attachment" "karpenter_node_worker_policy" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "karpenter_node_cni" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "karpenter_node_ecr" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "karpenter_node_ssm" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "karpenter_node_profile" {
  name = "${var.cluster_name}-karpenter-node-profile"
  role = aws_iam_role.karpenter_node.name
  tags = var.tags
}

