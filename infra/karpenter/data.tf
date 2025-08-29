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


# Controller policy (minimal set taken from Karpenter docs; tailor as needed)
data "aws_iam_policy_document" "karpenter_controller_policy" {
  statement {
    sid    = "KarpenterEC2Permissions"
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
