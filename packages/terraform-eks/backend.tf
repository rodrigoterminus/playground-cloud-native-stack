# Remote backend configuration for team collaboration
#
# WHY: Storing Terraform state remotely in S3 is critical for team environments.
# It enables:
# 1. State locking via DynamoDB (prevents concurrent modifications)
# 2. Shared state access (team members see the same infrastructure state)
# 3. State encryption and versioning for security and recovery
#
# ALTERNATIVE: Local state (terraform.tfstate file) works for solo learning
# but is unsuitable for production/team use due to no locking and no sharing.

terraform {
  backend "s3" {
    # S3 bucket for storing the Terraform state file
    bucket         = "playground-cloud-native-stack"
    key            = "terraform-eks/terraform.tfstate"
    region         = "eu-central-1"
    
    # DynamoDB table for state locking (prevents race conditions)
    # This table must exist before running terraform init
    dynamodb_table = "terraform-state-locks"
    
    # Encrypt state file at rest (contains sensitive data like outputs)
    encrypt        = true
  }

  # Terraform version constraint
  required_version = ">= 1.0"

  # Provider version constraints for reproducible builds
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
