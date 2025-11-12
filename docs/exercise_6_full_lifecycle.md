# Exercise 6: Full Lifecycle (Deploy App to EKS)

**Goal:** Combine all previous exercises into a single workflow. You will push your containerized app to ECR and deploy it on your live EKS cluster.

**Why:** This simulates the complete "dev-to-prod" CI/CD loop, demonstrating end-to-end ownership.

## Steps

1.  **Push Image to ECR:**
    * You need the ECR repository from Exercise 4.
    * Get Docker login credentials from the AWS CLI.
    * Tag your `python-api:latest` image with the full ECR repository URI (e.g., `<aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-cloud-api-repo:latest`).
    * `docker push <your-ecr-repo-uri>/python-api:latest`

2.  **Deploy to EKS:**
    * Make sure your `kubectl` is pointing to your EKS cluster (from Exercise 5).
    * Modify your `deployment.yaml` from Exercise 3 to use the new ECR image URI.
    * Modify your `service.yaml` from Exercise 3. Change the type from `NodePort` to **`LoadBalancer`**. This will automatically provision an AWS Elastic Load Balancer to expose your service to the internet.
    * `kubectl apply -f deployment.yaml -f service.yaml`

3.  **Verify:**
    * `kubectl get pods` (Watch them become "Running")
    * `kubectl get service` (Wait for the "EXTERNAL-IP" to show the ELB's DNS address)
    * Copy the ELB address and paste it into your browser. You should see your Python API!

4.  **Clean Up (Critical):**
    * `kubectl delete -f deployment.yaml -f service.yaml`
    * Go to your `terraform-eks` folder and run `terraform destroy`.
    * Go to your `terraform-s3` (or equivalent) folder and run `terraform destroy`.

## Key Copilot Prompts

* `"What is the AWS CLI command to get the docker login for ECR in the 'us-east-1' region?"`
* `"How do I tag my local docker image 'python-api:latest' for my ECR repository '<my-ecr-repo-uri>'?"`
* `"Modify my Kubernetes Service YAML to be type 'LoadBalancer' to expose it externally on AWS."`