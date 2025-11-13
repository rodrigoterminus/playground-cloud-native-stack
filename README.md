# Cloud-Native Playground: Python, K8s & Terraform on AWS

This repository is a personal playground for hands-on experimentation with a modern cloud-native stack. It contains a set of small, independent exercises to practice provisioning infrastructure, containerizing applications, and orchestrating deployments.

The focus is on the end-to-end workflow, from building a backend service to deploying it on a managed Kubernetes cluster in the cloud.

---

## 🚀 Technologies in Practice

This playground is built around the following core technologies:

* **Backend:** Python (FastAPI) & Node.js (NestJS)
* **Containerization:** Docker
* **Infrastructure as Code (IaC):** Terraform
* **Orchestration:** Kubernetes (EKS & `kubectl`)
* **Cloud Provider:** Amazon Web Services (AWS)

---

## 📂 What's Inside?

This repository is structured as a collection of self-contained projects, each demonstrating a piece of the stack.

* `/python-api`: A simple, containerized **FastAPI** application.
* `/node-api`: A simple, containerized **NestJS** application.
* `/terraform-aws-base`: Terraform code to provision foundational AWS resources (like an S3 bucket for state and an ECR repository for images).
* `/terraform-aws-eks`: Terraform code to provision a managed **AWS EKS (Elastic Kubernetes Service)** cluster using the official Terraform EKS module.

---

## 💡 How to Use

Each directory is designed to be used independently. The general workflow is:

1.  **Build Apps:** Use `docker build` within the `/python-api` or `/node-api` directories to create local container images.
2.  **Test Locally:** Use the manifests in `/local-k8s` with `kubectl apply` to test deployments on your local Kubernetes-enabled Docker Desktop.
3.  **Provision Cloud Infra:**
    * Navigate to `/terraform-aws-base` and run `terraform init`, `terraform plan`, and `terraform apply` to create your ECR repository.
    * Navigate to `/terraform-aws-eks` and do the same to provision your EKS cluster.
4.  **Deploy to Cloud:**
    * Push your local Docker images to your new AWS ECR repository.
    * Update the Kubernetes manifests to point to your ECR image URI.
    * Configure `kubectl` to point to your new EKS cluster (`aws eks update-kubeconfig ...`).
    * Use `kubectl apply` to deploy your application to AWS.

---

## ⚠️ Disclaimer

The configurations in this repository are for learning and demonstration purposes only. They are not intended for production use and may not include all best practices for security, high availability, or cost management.