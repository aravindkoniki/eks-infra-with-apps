locals {
  cluster_security_group_id = module.eks_control_plane.cluster_security_group_id
  node_security_group_id    = module.eks_node_group.node_security_group_id
}

# Allow nodes to communicate with the EKS API
resource "aws_security_group_rule" "nodes_to_api" {
  provider    = aws.MY_NETWORKING
  description = "Allow nodes to communicate with EKS API"
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = local.node_security_group_id
  security_group_id = local.cluster_security_group_id
}

# Allow EKS control plane to communicate with kubelet on nodes
resource "aws_security_group_rule" "api_to_nodes" {
  provider    = aws.MY_NETWORKING
  description = "Allow control plane to communicate with kubelet on nodes"
  type        = "ingress"
  from_port   = 10250
  to_port     = 10250
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = local.cluster_security_group_id
  security_group_id = local.node_security_group_id
}

# Allow DNS communication between CoreDNS and nodes (TCP & UDP)
resource "aws_security_group_rule" "dns_tcp" {
  provider    = aws.MY_NETWORKING
  description = "Allow DNS (TCP) between CoreDNS and nodes"
  type        = "ingress"
  from_port   = 53
  to_port     = 53
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = local.cluster_security_group_id
  security_group_id = local.node_security_group_id
}

resource "aws_security_group_rule" "dns_udp" {
  provider    = aws.MY_NETWORKING
  description = "Allow DNS (UDP) between CoreDNS and nodes"
  type        = "ingress"
  from_port   = 53
  to_port     = 53
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = local.cluster_security_group_id
  security_group_id = local.node_security_group_id
}
