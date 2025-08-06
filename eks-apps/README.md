Here’s your README.md in Markdown format with an ASCII traffic flow diagram that will render well on GitHub or any Markdown viewer.

⸻


# EKS Apps — NGINX Ingress with AWS NLB & Multi-Namespace Applications

This setup deploys:
- **NGINX Ingress Controller** in Amazon EKS
- **AWS Network Load Balancer (NLB)** (Internet-facing)
- **Two sample applications** (`app1` & `app2`) each in their own namespace
- Fully automated deployment with **Terraform** + Kubernetes **manifest files**
- Support for **private EKS worker nodes** with **public NLB**

---

## 📌 Traffic Flow

```text
[ User Browser Request ]
          |
          v
[ Route53 DNS ]
  (app1.example.com / app2.example.com)
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


⸻

📂 Folder Structure

eks-apps/
├── main.tf              # Terraform code to deploy NGINX ingress & apply manifests
├── variables.tf         # Variables for public subnets, kubeconfig path
├── outputs.tf           # Output for NLB DNS name
└── manifests/
    ├── namespaces/
    │   ├── app1-namespace.yaml
    │   └── app2-namespace.yaml
    ├── deployments/
    │   ├── app1-deployment.yaml
    │   └── app2-deployment.yaml
    ├── services/
    │   ├── app1-service.yaml
    │   └── app2-service.yaml
    └── ingress/
        ├── app1-ingress.yaml
        └── app2-ingress.yaml


⸻

⚙️ Terraform Usage

1️⃣ Prerequisites
	•	A running EKS cluster with:
	•	Worker nodes in private subnets
	•	At least one public subnet per AZ for the NLB
	•	kubectl configured to connect to the cluster
	•	terraform installed

⸻

2️⃣ Variables

In terraform.tfvars:

public_subnet_ids = [
  "subnet-0a1b2c3d4e5f6g7h8",
  "subnet-1a2b3c4d5e6f7g8h9",
  "subnet-2a3b4c5d6e7f8g9h0"
]

kubeconfig_path = "~/.kube/config"


⸻

3️⃣ Deploy

cd eks-apps
terraform init
terraform apply -auto-approve

Terraform will:
	•	Deploy the NGINX ingress controller using the Helm provider.
	•	Attach the NLB to public subnets.
	•	Apply all Kubernetes manifests in the manifests/ directory.

⸻

4️⃣ Get the NLB DNS Name

terraform output ingress_controller_nlb

Example:

ingress_controller_nlb = "a1b2c3d4e5f6g7h8.elb.amazonaws.com"


⸻

5️⃣ Configure Route53

In Route53, create A records:

app1.example.com → NLB DNS
app2.example.com → NLB DNS


⸻

6️⃣ Access Applications
	•	http://app1.example.com
	•	http://app2.example.com

⸻

🛡 Key Notes
	•	Public Subnets for NLB — Required for internet-facing access; nodes can still remain private.
	•	Ingress Rules — Handle routing based on hostname or path.
	•	Security — Limit inbound traffic using Security Groups & Route53.
	•	Scalability — Add more namespaces and deployments for new applications.