# Output values for the EKS cluster
#
# WHY: Outputs serve multiple purposes:
# 1. Provide information needed to configure kubectl and other tools
# 2. Can be consumed by other Terraform modules (via terraform_remote_state)
# 3. Display critical information after terraform apply
#
# SECURITY NOTE: Outputs are stored in the state file. Mark sensitive ones accordingly.

output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane (API server)"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true  # WHY: Contains cryptographic material
}

output "cluster_version" {
  description = "The Kubernetes server version for the cluster"
  value       = module.eks.cluster_version
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "node_group_id" {
  description = "EKS node group ID"
  value       = module.eks.eks_managed_node_groups["main"].node_group_id
}

output "node_group_iam_role_arn" {
  description = "IAM role ARN for the node group"
  value       = module.eks.eks_managed_node_groups["main"].iam_role_arn
}

output "configure_kubectl" {
  description = "Command to configure kubectl to connect to the EKS cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
