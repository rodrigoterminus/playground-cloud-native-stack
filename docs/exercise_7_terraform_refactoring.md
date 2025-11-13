# Exercise 7: Terraform Refactoring (Modules + DRY)

**Goal:** Refactor your Terraform infrastructure from Exercises 4-5 into a production-grade, modular architecture that follows the DRY principle.

**Why:** This demonstrates **Terraform best practices** used in real-world production environments. You'll learn how to create reusable modules, eliminate code duplication, and structure infrastructure for scalability. This is what you'll be expected to do in a DevOps/Platform Engineering role.

## What You'll Build

Transform this (current state):
```
packages/
├── terraform-aws-base/     # S3, ECR, DynamoDB (duplicated config)
└── terraform-aws-eks/      # EKS cluster (duplicated config)
```

Into this (production pattern):
```
terraform/
├── modules/                # Reusable components (DRY)
│   ├── remote-state/       # S3 + DynamoDB backend
│   ├── ecr-repository/     # ECR with security
│   ├── vpc/                # VPC configuration
│   └── eks-cluster/        # EKS wrapper module
│
└── environments/           # Environment-specific configs
    └── dev/                # Development environment
        ├── main.tf         # Composes modules
        ├── variables.tf
        ├── outputs.tf
        └── backend.tf
```

## Steps

### 1. Create the Module Structure

```bash
# From your project root
mkdir -p terraform/modules/{remote-state,ecr-repository,vpc,eks-cluster}
mkdir -p terraform/environments/dev
```

---

### 2. Extract S3/DynamoDB into a Module

**Create:** `terraform/modules/remote-state/main.tf`

* Move your S3 bucket and DynamoDB table resources from Exercise 4
* Parameterize with variables (bucket name, table name)
* Keep security features (versioning, encryption, public access block)

**Create:** `terraform/modules/remote-state/variables.tf`
* Define input variables for customization

**Create:** `terraform/modules/remote-state/outputs.tf`
* Export bucket name, ARN, DynamoDB table name

**Why a module?** 
* Reusable across multiple projects
* Consistent backend configuration
* Tested security settings

---

### 3. Extract ECR into a Module

**Create:** `terraform/modules/ecr-repository/main.tf`

* Move ECR repository and lifecycle policy from Exercise 4
* Parameterize repository name, image retention count
* Keep security features (scanning, encryption)

**Create:** `terraform/modules/ecr-repository/variables.tf`
* Repository name (required)
* Image retention count (default: 10)
* Scan on push (default: true)

**Create:** `terraform/modules/ecr-repository/outputs.tf`
* Repository URL (for docker push)
* Repository ARN
* Repository name

**Why a module?**
* You'll likely have multiple ECR repositories (python-api, node-api, etc.)
* Ensures consistent security policies
* Easy to create new repositories

---

### 4. Create VPC Module (or Use Official Module)

**Option A - Use Official Module (Recommended):**
* Reference the official `terraform-aws-modules/vpc/aws` module
* You've already done this in Exercise 5

**Option B - Create Your Own (Learning):**
* Create `terraform/modules/vpc/main.tf`
* Define VPC, subnets, internet gateway, NAT gateways
* This is complex - official module is better for production

---

### 5. Create EKS Wrapper Module

**Create:** `terraform/modules/eks-cluster/main.tf`

* Wrap the official EKS module with your company's defaults
* Set security group rules
* Configure managed node groups
* Add common tags

**Create:** `terraform/modules/eks-cluster/variables.tf`
* Cluster name (required)
* VPC ID (required)
* Subnet IDs (required)
* Node instance type (default: t3.medium)
* Desired node count (default: 2)

**Create:** `terraform/modules/eks-cluster/outputs.tf`
* Cluster endpoint
* Cluster name
* Cluster security group ID
* Kubeconfig command

**Why wrap the official module?**
* Enforce company standards (security groups, tags)
* Simplify interface for your team
* Easy to update official module without changing consumer code

---

### 6. Compose Modules in Dev Environment

**Create:** `terraform/environments/dev/main.tf`

```hcl
# Example structure (you'll build this)
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "terraform"
      Project     = "cloud-native-stack"
    }
  }
}

# Use your remote-state module
module "backend" {
  source = "../../modules/remote-state"
  
  bucket_name       = var.state_bucket_name
  dynamodb_table    = var.dynamodb_table_name
  environment       = "dev"
}

# Use your ECR module
module "python_api_ecr" {
  source = "../../modules/ecr-repository"
  
  repository_name       = "python-api"
  image_retention_count = 10
}

module "node_api_ecr" {
  source = "../../modules/ecr-repository"
  
  repository_name       = "node-api"
  image_retention_count = 10
}

# Use VPC module (official or yours)
module "vpc" {
  source = "../../modules/vpc"
  
  # Configure VPC...
}

# Use your EKS wrapper module
module "eks" {
  source = "../../modules/eks-cluster"
  
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
}
```

**Create:** `terraform/environments/dev/variables.tf`
* Define all variables needed by modules
* Set sensible defaults for dev environment

**Create:** `terraform/environments/dev/outputs.tf`
* Re-export important module outputs
* ECR repository URLs
* EKS cluster endpoint
* Backend bucket name

**Create:** `terraform/environments/dev/backend.tf`
* Configure S3 backend (using the bucket you created)
* Use remote state for collaboration

---

### 7. Test the Refactored Infrastructure

```bash
cd terraform/environments/dev

# Initialize (downloads modules)
terraform init

# Review the plan
terraform plan

# Apply (creates all resources using modules)
terraform apply

# Verify modules are working
terraform output ecr_python_api_url
terraform output eks_cluster_endpoint
```

---

### 8. Verify Module Reusability

**Create a staging environment** to prove modules are reusable:

```bash
mkdir -p terraform/environments/staging
cd terraform/environments/staging

# Copy dev configuration
cp ../dev/*.tf .

# Modify variables for staging
# - Different bucket name
# - Different cluster name
# - Same modules!

terraform init
terraform plan
```

**You should see:**
* Same modules used in both environments
* Different resource names (dev vs staging)
* No code duplication!

---

### 9. Compare Before/After

Run this to see the improvement:

```bash
# Before (duplicated code)
wc -l packages/terraform-aws-base/*.tf
wc -l packages/terraform-aws-eks/*.tf

# After (DRY modules)
wc -l terraform/modules/*/*.tf
wc -l terraform/environments/dev/*.tf
```

**You should see:**
* Modules have the logic (more lines)
* Environments are thin wrappers (fewer lines)
* Adding a new environment = copy & modify variables (not code)

---

### 10. Clean Up (Cost Control)

```bash
# Destroy everything in dev
cd terraform/environments/dev
terraform destroy

# If you created staging
cd ../staging
terraform destroy

# Keep your old directories for reference
# (Don't delete packages/terraform-aws-base yet)
```

---

## Key Copilot Prompts

* `"Convert my S3 bucket and DynamoDB table resources into a reusable Terraform module with proper variables and outputs."`
* `"Create a Terraform module that wraps the official EKS module and enforces my company's security standards."`
* `"Generate a root module that composes my custom modules for a dev environment."`
* `"How do I reference outputs from one module in another module within the same Terraform configuration?"`
* `"Show me how to version my Terraform modules using Git tags and reference specific versions."`

---

## What You've Learned

### Before (Exercises 4-5):
❌ Code duplication across directories  
❌ Hard to maintain consistency  
❌ Manual coordination between resources  
❌ Difficult to add new environments  

### After (Exercise 7):
✅ **DRY:** Modules eliminate duplication  
✅ **Reusable:** Same modules for dev/staging/prod  
✅ **Composable:** Mix and match modules  
✅ **Testable:** Test modules independently  
✅ **Scalable:** Easy to add environments  
✅ **Maintainable:** Update modules, all environments benefit  
✅ **Production-ready:** Matches industry best practices  

---

## Bonus Challenges

### Challenge 1: Module Versioning
* Push modules to a separate Git repository
* Tag versions (v1.0.0, v1.1.0)
* Reference modules by version in environments

```hcl
module "eks" {
  source = "git::https://github.com/yourorg/terraform-modules.git//eks-cluster?ref=v1.0.0"
  # ...
}
```

### Challenge 2: Terragrunt
* Install Terragrunt
* Convert to Terragrunt structure
* Eliminate backend.tf duplication

### Challenge 3: Multi-Environment
* Create `terraform/environments/prod/`
* Use same modules, different variable values
* Separate AWS accounts for dev/prod (advanced)

### Challenge 4: Module Testing
* Use `terraform-compliance` to test module policies
* Use `terratest` (Go) to integration test modules
* Add CI/CD to test modules on PR

### Challenge 5: Terraform Registry
* Publish your modules to a private Terraform Registry
* Use semantic versioning
* Document module inputs/outputs

---

## Architecture Diagram

```
terraform/
├── modules/                          # Reusable building blocks
│   ├── remote-state/
│   │   ├── main.tf                   # S3 + DynamoDB logic
│   │   ├── variables.tf              # Parameterized
│   │   └── outputs.tf                # Exportable values
│   │
│   ├── ecr-repository/
│   │   ├── main.tf                   # ECR logic (DRY)
│   │   ├── variables.tf              # Scan on push, retention, etc.
│   │   └── outputs.tf                # Repository URL
│   │
│   ├── vpc/
│   │   └── ...                       # VPC configuration
│   │
│   └── eks-cluster/
│       └── ...                       # EKS wrapper
│
└── environments/                     # Consumers of modules
    ├── dev/
    │   ├── main.tf                   # module "ecr" { source = "../../modules/ecr" }
    │   ├── variables.tf              # Dev-specific values
    │   ├── outputs.tf                # Re-export module outputs
    │   ├── backend.tf                # S3 backend config
    │   └── terraform.tfstate         # Dev state (isolated)
    │
    └── staging/
        ├── main.tf                   # Same modules, different vars
        ├── variables.tf              # Staging-specific values
        ├── outputs.tf
        ├── backend.tf
        └── terraform.tfstate         # Staging state (isolated)
```

---

## Success Criteria

You've completed Exercise 7 when:

- ✅ You have 4+ reusable modules in `terraform/modules/`
- ✅ Your `dev` environment uses all modules (no hardcoded resources)
- ✅ You can create a `staging` environment by copying 4 files + changing variables
- ✅ `terraform plan` in dev shows all resources managed via modules
- ✅ You understand module inputs, outputs, and composition
- ✅ You can explain why this architecture is better than Exercises 4-5

---

## Real-World Impact

This exercise teaches you the **#1 skill** for Terraform in production:

> "Build reusable infrastructure components that scale across environments."

**In your technical assessment:**
* Demonstrate you understand module patterns
* Show you can refactor for maintainability
* Prove you think beyond "just making it work"

**In your job:**
* You'll build module libraries for your team
* You'll maintain consistency across 10+ AWS accounts
* You'll enable self-service infrastructure for developers

This is the difference between a **Terraform user** and a **Platform Engineer**.

---

## Next Steps

After mastering this:
1. Review the [Terraform Module Registry](https://registry.terraform.io/) for inspiration
2. Study how companies like Gruntwork structure their modules
3. Practice explaining your architecture in a technical interview
4. Add this to your portfolio/GitHub with good documentation

**You're now ready for production Terraform work!** 🚀
