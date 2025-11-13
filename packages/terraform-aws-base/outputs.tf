output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "s3_bucket_region" {
  description = "The AWS region of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.region
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.terraform_state.bucket_domain_name
}

output "python_api_ecr_repository_url" {
  description = "The URL of the Python API ECR repository (use this for docker push/pull)"
  value       = aws_ecr_repository.python_api.repository_url
}

output "python_api_ecr_repository_arn" {
  description = "The ARN of the Python API ECR repository"
  value       = aws_ecr_repository.python_api.arn
}

output "python_api_ecr_repository_name" {
  description = "The name of the Python API ECR repository"
  value       = aws_ecr_repository.python_api.name
}

output "node_api_ecr_repository_url" {
  description = "The URL of the Node API ECR repository (use this for docker push/pull)"
  value       = aws_ecr_repository.node_api.repository_url
}

output "node_api_ecr_repository_arn" {
  description = "The ARN of the Node API ECR repository"
  value       = aws_ecr_repository.node_api.arn
}

output "node_api_ecr_repository_name" {
  description = "The name of the Node API ECR repository"
  value       = aws_ecr_repository.node_api.name
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = aws_dynamodb_table.terraform_locks.arn
}
