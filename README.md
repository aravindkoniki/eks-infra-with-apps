# 🧭 EKS Terraform Architecture – Overview

This project automates a **fully private EKS cluster** setup across **3 AZs**, with the following key components:

- 📦 Private VPC with subnets in 3 AZs  
- ☸️ EKS Control Plane (private-only access)  
- 🧩 Managed Node Groups (one per subnet to support Karpenter)  
- 🔒 IAM OIDC Provider  
- 🔧 ConfigMap `aws-auth`  
- ⚙️ Karpenter (autoscaler for dynamic provisioning)

---

## 🔍 Why Use an OIDC Provider in EKS?

**OIDC (OpenID Connect)** is used to securely allow Kubernetes workloads (like Karpenter) to assume IAM roles **without needing static credentials or attaching IAM roles to nodes**.

### ✅ Benefits:
- Enables **IAM Roles for Service Accounts (IRSA)**
- Lets you assign fine-grained IAM permissions to specific pods
- Karpenter **requires** OIDC to assume its own IAM role for provisioning EC2 instances

### 📌 Terraform Code:
We create the OIDC provider using the EKS cluster's identity issuer URL and AWS IAM, enabling IRSA:
```hcl
resource "aws_iam_openid_connect_provider" "oidc" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["<thumbprint>"]
}
```

---

## 🔍 Why Do We Need the `aws-auth` ConfigMap?

The `aws-auth` ConfigMap in the `kube-system` namespace controls **which IAM roles and users** can join the EKS cluster as **worker nodes or admins**.

### ✅ Why it’s critical:
- Allows EKS-managed node groups to **join the control plane**
- Maps EC2 instances (via their IAM role) to Kubernetes node identities

### ⚙️ Example ConfigMap:
```yaml
mapRoles:
  - rolearn: arn:aws:iam::123456789012:role/eks-node-role
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
```

### 📌 Terraform Code:
We automate this using the `kubernetes_config_map` resource and inject the correct IAM role dynamically:
```hcl
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = var.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }
}
```

---

## 🚀 What is Karpenter and Why Do We Use It?

[Karpenter](https://karpenter.sh/) is an open-source autoscaler designed for Kubernetes on AWS. Unlike the native Cluster Autoscaler, Karpenter:
- **Launches nodes faster**
- Supports **just-in-time provisioning** based on actual pod needs
- Allows **fine-grained instance selection** (spot/on-demand, size, arch)

### ✅ In Our Setup:
- We use a minimal bootstrap node group (one per AZ)
- Karpenter launches additional nodes as required based on pending pods
- OIDC + IRSA lets Karpenter authenticate securely

---

## 📦 Directory Structure

| Folder         | Purpose                                |
|----------------|----------------------------------------|
| `vpc/`         | Creates private VPC and subnets         |
| `eks/`         | EKS control plane + node groups         |
| `karpenter/`   | (Optional) Karpenter Helm setup         |
| `oidc.tf`      | Defines the IAM OIDC provider           |
| `aws_auth.tf`  | Manages `aws-auth` ConfigMap            |

---

## 🛠️ Next Steps

- Set up the [Karpenter Controller](https://karpenter.sh/docs/getting-started/) via Helm
- Create **Provisioners** for different instance types / zones
- Configure Spot + On-Demand preferences