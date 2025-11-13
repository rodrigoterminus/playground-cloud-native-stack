# Main Terraform configuration for EKS cluster provisioning
#
# WHY: Using the official terraform-aws-modules/eks module instead of defining
# all resources manually follows the DRY (Don't Repeat Yourself) principle.
# This module:
# 1. Encapsulates AWS best practices (security, networking, IAM)
# 2. Reduces boilerplate (~1000+ lines of raw Terraform)
# 3. Is maintained by the community and updated for new EKS features
#
# ALTERNATIVE: Manually defining aws_eks_cluster, aws_eks_node_group, IAM roles,
# security groups, etc. is possible but error-prone and verbose.

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.tags,
      {
        Environment = var.environment
      }
    )
  }
}

# VPC Module
# WHY: EKS requires a VPC with specific subnet tagging for LoadBalancers.
# This module handles all the complexity (subnets, NAT gateways, route tables).
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  # High availability: Use 3 availability zones
  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Enable NAT Gateway for private subnet internet access (required for node groups)
  enable_nat_gateway   = true
  single_nat_gateway   = true  # Cost optimization for dev (use one per AZ for prod)
  enable_dns_hostnames = true
  enable_dns_support   = true

  # EKS-specific subnet tags
  # WHY: These tags allow EKS to discover subnets for LoadBalancer provisioning
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# EKS Cluster Module
# WHY: This official module handles 50+ resources needed for a production-grade EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Network configuration
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Cluster endpoint access
  # WHY: Public access allows kubectl from your laptop. For production, consider
  # restricting to VPN/bastion or using private-only access.
  cluster_endpoint_public_access = true

  # EKS Managed Node Group
  # WHY: Managed node groups are simpler than self-managed (EC2 Auto Scaling Groups).
  # AWS handles AMI updates, patching, and scaling.
  eks_managed_node_groups = {
    main = {
      name = "${var.cluster_name}"

      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"  # ALTERNATIVE: "SPOT" for cost savings with availability risk

      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Security: Use a dedicated IAM role per node group
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      # Update configuration for rolling updates
      update_config = {
        max_unavailable_percentage = 33
      }

      tags = {
        NodeGroup = "main"
      }
    }
  }

  # Cluster access management
  # WHY: This configures which AWS IAM principals can access the cluster
  # The creator's IAM user/role is automatically added
#   enable_cluster_creator_admin_permissions = true

  tags = var.tags
}

# Security Group Rules
# WHY: Allow communication between control plane and worker nodes
# The module handles most of this, but you can add custom rules here if needed
