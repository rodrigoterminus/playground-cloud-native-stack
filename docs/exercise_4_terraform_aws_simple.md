# Exercise 4: Terraform + AWS (Simple Resource)

**Goal:** Practice the core Terraform workflow by provisioning simple AWS resources.

**Why:** This exercise isolates the `terraform` syntax and state management concepts. The job requires **Terraform for AWS provisioning**. Your resume lists AWS CDK, so this connects that IaC concept to the new tool.

## Steps

1.  **Create Project:**
    * Create a new directory (e.g., `terraform-s3`).
    * `cd` into it.

2.  **Create Configuration:**
    * Create a `main.tf` file.
    * Use Copilot to write Terraform code to provision an **AWS S3 bucket**.
    * Add a second resource: an **AWS ECR repository**. This will be needed in Exercise 6.

3.  **Practice Core Workflow:**
    * This is the key loop to memorize. Run this cycle 2-3 times.
    * `terraform init`
        * *What it does:* Initializes the backend and downloads the AWS provider.
    * `terraform plan`
        * *What it does:* Shows you what changes will be made.
    * `terraform apply`
        * *What it- does:* Prompts you to approve the plan and creates the resources.
    * `terraform destroy`
        * *What it does:* Cleans up all resources managed by this configuration.

## Key Copilot Prompts

* `"Create a Terraform 'main.tf' to provision an AWS S3 bucket. Include the 'aws' provider. Use a variable for the bucket name to ensure it's unique."`
* `"Add a resource to my Terraform 'main.tf' to create an AWS ECR repository named 'my-cloud-api-repo'."`
* `"Now, add a remote state backend to this Terraform configuration using the S3 bucket I just created."` (This is a good stretch goal).