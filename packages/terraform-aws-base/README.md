# Terraform AWS Base Infrastructure

This Terraform configuration provisions basic AWS resources including an S3 bucket for state storage.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with credentials
- IAM permissions for S3 operations

## File Structure

```
terraform-aws-base/
├── main.tf                  # Primary resource definitions
├── variables.tf             # Input variable declarations
├── outputs.tf               # Output value definitions
├── terraform.tfvars.example # Example variable values
├── .gitignore               # Git ignore patterns
└── README.md                # This file
```

## Quick Start

1. **Copy and customize variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your unique bucket name
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   This downloads the AWS provider and initializes the backend.

3. **Preview changes:**
   ```bash
   terraform plan
   ```
   Review what resources will be created.

4. **Apply configuration:**
   ```bash
   terraform apply
   ```
   Type `yes` to confirm and create the resources.

5. **View outputs:**
   ```bash
   terraform output
   ```

6. **Clean up (when done):**
   ```bash
   terraform destroy
   ```
   **Important:** This deletes all managed resources to avoid AWS charges.

## Resources Created

- **S3 Bucket** with:
  - Versioning enabled (for state file protection)
  - Server-side encryption (AES256)
  - Public access blocked (security best practice)
  - Default tags for organization

## Configuration

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region | `us-east-1` | No |
| `bucket_name` | S3 bucket name (must be globally unique) | - | Yes |
| `environment` | Environment (dev/staging/prod) | `dev` | No |

### Passing Variables

**Option 1:** `terraform.tfvars` file
```hcl
bucket_name = "my-unique-bucket-name"
```

**Option 2:** Command line
```bash
terraform apply -var="bucket_name=my-unique-bucket-name"
```

**Option 3:** Environment variable
```bash
export TF_VAR_bucket_name="my-unique-bucket-name"
terraform apply
```

## Best Practices Implemented

✅ **Separation of concerns:** Dedicated files for variables, outputs, and resources  
✅ **Versioning enabled:** S3 bucket versioning protects against accidental deletions  
✅ **Encryption:** Server-side encryption enabled by default  
✅ **Security:** Public access blocked on S3 bucket  
✅ **Validation:** Input validation on variables  
✅ **Tagging:** Default tags for resource organization  
✅ **Documentation:** Clear README and variable descriptions  

## Next Steps (Stretch Goals)

1. **Add ECR Repository:** Extend this config to include an ECR repository for container images
2. **Remote State:** Configure S3 backend for state storage (requires DynamoDB table for locking)
3. **Modules:** Extract reusable components into Terraform modules

## IAM Permissions Required

Your AWS user/role needs these permissions:
- `s3:CreateBucket`
- `s3:DeleteBucket`
- `s3:PutBucketVersioning`
- `s3:PutEncryptionConfiguration`
- `s3:PutBucketPublicAccessBlock`
- `s3:GetBucket*` (for reads)

## Cost Considerations

- **S3 bucket:** Free tier includes 5GB storage; minimal cost for state files
- **Data transfer:** Negligible for state file operations
- Remember to run `terraform destroy` when done to avoid charges
