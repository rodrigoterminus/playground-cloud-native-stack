# Remote backend configuration for team collaboration
# 
# This configures Terraform to store state in S3 with DynamoDB locking.
 
terraform {
  backend "s3" {
    # Replace these values with your actual bucket name and region
    bucket         = "playground-cloud-native-stack"
    key            = "terraform-aws-base/terraform.tfstate"
    region         = "eu-central-1"
    
    # DynamoDB table for state locking (prevents concurrent modifications)
    dynamodb_table = "terraform-state-locks"
    
    # Enable encryption for state file security
    encrypt        = true
  }
}
