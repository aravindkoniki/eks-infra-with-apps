#!/bin/bash

# Get AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile MY_NETWORKING)

echo "Deploying UI Apps to EKS cluster..."
echo "AWS Account ID: $AWS_ACCOUNT_ID"

# Replace ACCOUNT_ID placeholder in manifests
find manifests/ -name "*.yaml" -exec sed -i.bak "s/ACCOUNT_ID/$AWS_ACCOUNT_ID/g" {} \;

# Apply manifests
echo "Creating namespaces..."
kubectl apply -f manifests/namespaces/

echo "Deploying applications..."
kubectl apply -f manifests/deployments/
kubectl apply -f manifests/services/

echo "Configuring ingress..."
kubectl apply -f manifests/ingress/

# Check deployment status
echo "Checking deployment status..."
kubectl get pods -n ui-app1
kubectl get pods -n ui-app2

echo "Checking services..."
kubectl get svc -n ui-app1
kubectl get svc -n ui-app2

echo "Checking ingress..."
kubectl get ingress -n ui-app1
kubectl get ingress -n ui-app2

# Get nginx ingress controller service (NLB endpoint)
echo "Getting nginx ingress controller endpoint..."
kubectl get svc -n nginx-ingress

# Clean up backup files
find manifests/ -name "*.bak" -delete

echo "Deployment complete!"
echo ""
echo "Access your applications at:"
echo "- UI App1: https://app1.cloudcraftlab.work"
echo "- UI App2: https://app2.cloudcraftlab.work"
echo ""
echo "Make sure your DNS points to the NLB endpoint:"
kubectl get svc -n nginx-ingress -o wide