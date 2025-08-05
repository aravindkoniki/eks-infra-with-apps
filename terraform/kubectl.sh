#!/bin/bash
set -e

# Update packages
yum update -y
yum install -y unzip jq curl

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Get EKS cluster version dynamically
CLUSTER_VERSION=$(aws eks describe-cluster \
  --name ${var.eks_cluster_name} \
  --region ${var.region} \
  --query "cluster.version" \
  --output text)

# Get latest kubectl URL for that version
KUBECTL_URL=$(curl -s https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html | \
grep -o "https://s3.*${CLUSTER_VERSION}.*linux/amd64/kubectl" | head -n 1)

# Download and install kubectl
curl -Lo /usr/local/bin/kubectl $KUBECTL_URL
chmod +x /usr/local/bin/kubectl

# Verify
aws --version
kubectl version --client

# set up sso profile 
# aws eks update-kubeconfig --name private-eks --region eu-west-1 --profile MY_NETWORKING
# kubectl apply -f aws-auth.yaml
# kubectl get nodes -o wide