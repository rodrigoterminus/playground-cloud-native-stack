# Exercise 5: Terraform + AWS EKS Cluster

**Goal:** Provision the *exact* infrastructure mentioned in the job description: **EKS** using **Terraform**.

**Why:** This is the "boss level" for the infrastructure part of the assessment. It combines the two key DevOps tools.

## Steps

1.  **Create Project:**
    * Create a new directory (e.g., `terraform-eks`).
    * `cd` into it.

2.  **Create Configuration:**
    * Create a `main.tf`.
    * Use Copilot to get the configuration for the **official Terraform EKS module**. This is the standard best practice.

3.  **Provision Cluster:**
    * `terraform init`
    * `terraform plan`
    * `terraform apply`
    * **Be patient:** This will take 10-15 minutes to provision.

4.  **Configure `kubectl`:**
    * Once applied, you need to configure your local `kubectl` to talk to the new EKS cluster.
    * Use the AWS CLI for this.

5.  **Verify:**
    * Run `kubectl get nodes`.
    * If you see your new EKS nodes, you have succeeded.

6.  **Clean Up:**
    * **IMPORTANT:** Run `terraform destroy` as soon as you are done verifying. EKS clusters and their related resources (like NAT Gateways) incur costs.

## Key Copilot Prompts

* `"Using the official Terraform EKS module, generate a 'main.tf' to provision a basic EKS cluster. Include the VPC module as well."`
* `"What AWS CLI command do I run to update my kubeconfig for an EKS cluster? The cluster name is 'my-eks-cluster' and the region is 'us-east-1'."`
    * *(Anticipated answer: `aws eks update-kubeconfig --name my-eks-cluster --region us-east-1`)*