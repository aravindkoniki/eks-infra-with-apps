# EKS Apps — NGINX Ingress with AWS NLB & Multi-Namespace Applications
# EKS Apps — NGINX Ingress with AWS NLB & Multi-Namespace Applications

## 📂 eks-apps Folder Overview

This folder contains all Kubernetes and Terraform resources to deploy a production-grade, multi-namespace application stack on Amazon EKS. It includes:

- **Helm charts** for NGINX Ingress Controller (with AWS NLB integration)
- **Terraform** modules for EKS, NLB, Route53, and supporting AWS resources
- **Kubernetes manifests** for deployments, services, namespaces, and ingress for two sample apps (`app1` and `app2`)
- **Scripts** for automated deployment and testing

### Folder Structure

- `manifests/` — All Kubernetes YAMLs for deployments, services, ingress, and namespaces
- `helm/` — Helm values/templates for NGINX Ingress
- `scripts/` — Shell scripts for deployment and testing
- `*.tf` — Terraform files for AWS infrastructure and Kubernetes resources

---

## 📈 Network Traffic Flowchart

```mermaid
[ User Browser Request ]
          |
          v
[ Route53 DNS ]
  (app1.cloudcraftlab.work / app2.cloudcraftlab.work)
          |
          v
[ AWS NLB (Public Subnets) ]
          |
          v
[ NGINX Ingress Controller Pods ]
  (ingress-nginx namespace)
          |
          v
[ Ingress Resource ]
  (host-based routing)
          |
          v
[ Kubernetes Service ]
          |
          v
[ Application Pods ]
  (app1 namespace / app2 namespace)
```

---

## 🔗 Connecting to Your EKS Cluster

```sh
# Update kubeconfig for your EKS cluster
aws eks --region <region> update-kubeconfig --name <cluster-name> --profile <aws-profile>

# Verify connection
kubectl config current-context
kubectl get nodes -o wide
kubectl get namespaces
kubectl cluster-info
```

---

## ✅ Verifying Deployments

```sh
# Check all pods in all namespaces
kubectl get pods -A -o wide

# Check deployments, services, and ingress
kubectl get deployments -A
kubectl get svc -A
kubectl get ingress -A

# Check endpoints for services
kubectl get endpoints -A

# Check NGINX Ingress Controller
kubectl get pods -n ingress-nginx
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

---

## 🛠️ Troubleshooting Commands

```sh
# Pod logs and status
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>

# Service and endpoint issues
kubectl describe svc <service-name> -n <namespace>
kubectl get endpoints -n <namespace>

# Ingress troubleshooting
kubectl describe ingress <ingress-name> -n <namespace>

# Events (sorted by time)
kubectl get events -A --sort-by='.metadata.creationTimestamp'

# Restart a deployment
kubectl rollout restart deployment <name> -n <namespace>

# Exec into a pod
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
```

---