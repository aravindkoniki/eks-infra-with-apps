#!/bin/bash

echo "Testing UI Applications..."

echo "Testing UI App1..."
echo "GET http://app1.cloudcraftlab.work"
curl -k http://app1.cloudcraftlab.work

echo ""
echo "Testing UI App2..."
echo "GET http://app2.cloudcraftlab.work"
curl -k http://app2.cloudcraftlab.work

echo ""
echo "Testing UI App1 hostname endpoint..."
echo "GET http://app1.cloudcraftlab.work/hostname"
curl -k http://app1.cloudcraftlab.work/hostname

echo ""
echo "Testing UI App2 hostname endpoint..."
echo "GET http://app2.cloudcraftlab.work/hostname"
curl -k http://app2.cloudcraftlab.work/hostname

echo ""
echo "Getting ingress status..."
kubectl get ingress -n ui-app1
kubectl get ingress -n ui-app2

echo ""
echo "Getting nginx ingress controller endpoint..."
kubectl get svc -n nginx-ingress