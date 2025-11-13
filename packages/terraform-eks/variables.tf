# Input variables for the EKS cluster configuration
#
# WHY: Separating variables from main.tf enables:
# 1. Reusability across environments (dev/staging/prod)
# 2. Clear documentation of configurable parameters
# 3. Security (sensitive values can be passed via .tfvars or env vars)

variable "aws_region" {
  description = "AWS region where the EKS cluster will be provisioned"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "playground-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name for tagging and organization"
  type        = string
  default     = "development"
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "playground-cloud-native-stack"
    ManagedBy = "Terraform"
  }
}
