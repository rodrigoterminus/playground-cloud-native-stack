# Terraform EKS Cluster

This directory contains Terraform configuration to provision a production-grade AWS EKS (Elastic Kubernetes Service) cluster with all supporting infrastructure (VPC, subnets, NAT gateways, security groups, IAM roles).

## Architecture

**Why this approach:**
- Uses the **official AWS EKS Terraform module** (industry best practice)
- Implements **remote state** in S3 with DynamoDB locking (essential for team collaboration)
- Follows **separation of concerns** principle (backend, variables, main, outputs)
- Applies **Principle of Least Privilege** for IAM permissions
- Enables **high availability** with multi-AZ deployment

**vs. Alternative approaches:**
- ❌ Manual resource definitions: ~1000+ lines of error-prone code
- ❌ Local state: No locking, unsuitable for teams
- ❌ Hard-coded values: Not reusable across environments

## Prerequisites

1. **AWS CLI** configured with credentials
2. **Terraform** >= 1.0 installed
3. **S3 bucket** and **DynamoDB table** for remote state (created in terraform-aws-base)
4. **kubectl** installed for cluster verification

## File Structure

```
terraform-eks/
├── backend.tf              # Remote state configuration (S3 + DynamoDB)
├── variables.tf            # Input variables with defaults
├── main.tf                 # Core infrastructure (VPC + EKS modules)
├── outputs.tf              # Output values for kubectl configuration
├── terraform.tfvars.example # Example variable values (copy & customize)
├── .gitignore              # Exclude state files and secrets
└── README.md               # This file
```

## Required IAM Permissions

**Principle of Least Privilege:** The IAM user/role running Terraform needs:

- `ec2:*` (VPC, subnets, security groups, NAT gateways)
- `eks:*` (EKS cluster and node groups)
- `iam:*` (service roles for EKS and node groups)
- `s3:GetObject`, `s3:PutObject` (for remote state)
- `dynamodb:PutItem`, `dynamodb:GetItem`, `dynamodb:DeleteItem` (for state locking)

For production, use a more restrictive policy based on [AWS EKS IAM documentation](https://docs.aws.amazon.com/eks/latest/userguide/security-iam.html).

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

This downloads provider plugins and configures the S3 backend.

### 2. Create terraform.tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

**Security Note:** `terraform.tfvars` is gitignored. Never commit secrets.

### 3. Plan Infrastructure

```bash
terraform plan
```

Review the ~50+ resources that will be created.

### 4. Provision Cluster

```bash
terraform apply
```

**⏱️ This takes 10-15 minutes.** AWS provisions:
- VPC with 3 public + 3 private subnets
- NAT Gateway, Internet Gateway, route tables
- EKS control plane (managed by AWS)
- EKS managed node group (EC2 instances)

### 5. Configure kubectl

After `apply` completes, run the command from the output:

```bash
aws eks update-kubeconfig --name playground-eks-cluster --region eu-central-1
```

**Why this command:**
- Updates your `~/.kube/config` with cluster credentials
- Configures authentication using AWS IAM
- Alternative: Manual kubeconfig editing (error-prone)

### 6. Verify Cluster

```bash
kubectl get nodes
```

You should see 2 nodes (or your configured `desired_size`) in `Ready` state.

```bash
kubectl get all --all-namespaces
```

Verify system pods (CoreDNS, kube-proxy, AWS VPC CNI) are running.

### 7. Clean Up

**⚠️ IMPORTANT:** EKS clusters incur costs (~$0.10/hour for control plane + EC2 costs).

```bash
terraform destroy
```

Confirm by typing `yes`. This takes ~10 minutes.

## Cost Considerations

**Resources that incur charges:**
- EKS control plane: ~$0.10/hour ($73/month)
- EC2 instances (t3.medium): ~$0.042/hour each
- NAT Gateway: ~$0.045/hour + data transfer
- EBS volumes (for node storage)

**Estimated monthly cost (if left running):** ~$150-200 USD

Always `terraform destroy` when done experimenting.

## Troubleshooting

### Error: State locking failed

**Cause:** DynamoDB table doesn't exist or wrong permissions.

**Solution:**
```bash
cd ../terraform-aws-base
terraform apply  # Creates the locking table
```

### Error: Cluster creation timeout

**Cause:** Insufficient IAM permissions or VPC quota limits.

**Solution:** Check CloudTrail logs and IAM policies.

### kubectl: Unable to connect

**Cause:** kubeconfig not updated or wrong region.

**Solution:**
```bash
aws eks update-kubeconfig --name playground-eks-cluster --region eu-central-1
kubectl config current-context  # Should show arn:aws:eks:...
```

## Stretch Goals

After completing the basic setup, try these enhancements:

1. **Add AWS Load Balancer Controller:**
   - Enables Kubernetes `Ingress` resources to provision AWS ALB/NLB
   - Install via Helm or Terraform `helm_release` resource

2. **Enable IRSA (IAM Roles for Service Accounts):**
   - Allows pods to assume IAM roles without node-level permissions
   - More secure than storing AWS credentials in pods

3. **Add Cluster Autoscaler:**
   - Automatically scales node groups based on pod resource requests
   - Essential for production workloads

4. **Implement GitOps with FluxCD/ArgoCD:**
   - Declarative application deployment
   - Connects to your EKS cluster and syncs from Git

5. **Add monitoring with Prometheus/Grafana:**
   - Deploy via `kube-prometheus-stack` Helm chart
   - Visualize cluster and application metrics

## Connection to Your Experience

**For AWS CDK users:** Terraform modules are analogous to CDK constructs. Both provide high-level abstractions over raw API calls. The key difference:
- CDK: Imperative code (TypeScript/Python) → synthesizes CloudFormation
- Terraform: Declarative HCL → manages state directly

**For SDLC:** This EKS cluster becomes the runtime for your CI/CD pipeline deployments (e.g., deploying the `node-api` and `python-api` from previous exercises).

## References

- [AWS EKS Terraform Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [AWS VPC Terraform Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [Terraform Remote State Best Practices](https://developer.hashicorp.com/terraform/language/state/remote)
