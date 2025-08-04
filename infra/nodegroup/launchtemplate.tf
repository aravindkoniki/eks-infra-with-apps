# Launch Template for Karpenter
resource "aws_launch_template" "karpenter_lt" {
  name_prefix   = "${var.cluster_name}-karpenter-"
  image_id      = data.aws_ami.eks_default.id
  instance_type = var.instance_types[0]
  user_data     = base64encode("#!/bin/bash\n/etc/eks/bootstrap.sh ${var.cluster_name}")

  iam_instance_profile {
    name = aws_iam_instance_profile.karpenter_node.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "karpenter-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}