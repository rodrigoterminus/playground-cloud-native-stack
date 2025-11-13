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
      Project     = "cloud-native-stack"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}

# S3 bucket for Terraform state storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Description = "S3 bucket for Terraform state and application data"
  }
}

# Enable versioning for state file protection and recovery
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for security
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access for security
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ECR repository for Python API
resource "aws_ecr_repository" "python_api" {
  name                 = var.python_api_ecr_name
  image_tag_mutability = "MUTABLE"

  # Security: Scan images for vulnerabilities on push
  image_scanning_configuration {
    scan_on_push = true
  }

  # Security: Encrypt images at rest
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = var.python_api_ecr_name
    Description = "Container registry for Python FastAPI application"
  }
}

# Lifecycle policy for Python API images
resource "aws_ecr_lifecycle_policy" "python_api" {
  repository = aws_ecr_repository.python_api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ECR repository for Node API
resource "aws_ecr_repository" "node_api" {
  name                 = var.node_api_ecr_name
  image_tag_mutability = "MUTABLE"

  # Security: Scan images for vulnerabilities on push
  image_scanning_configuration {
    scan_on_push = true
  }

  # Security: Encrypt images at rest
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = var.node_api_ecr_name
    Description = "Container registry for Node.js NestJS application"
  }
}

# Lifecycle policy for Node API images
resource "aws_ecr_lifecycle_policy" "node_api" {
  repository = aws_ecr_repository.node_api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST" # Cost-effective: only pay for actual usage
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Enable point-in-time recovery for state lock table
  point_in_time_recovery {
    enabled = true
  }

  # Enable encryption at rest
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = var.dynamodb_table_name
    Description = "DynamoDB table for Terraform state locking"
  }
}
