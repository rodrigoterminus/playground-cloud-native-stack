# Exercise 3: Local Kubernetes Deployment (kubectl Deep Dive)

**Goal:** Get comfortable with the core `kubectl` commands using your local Kubernetes cluster (Docker Desktop or Minikube).

**Why:** The assessment prerequisites *require* `kubectl`. This exercise builds "command-line comfort" and "muscle memory" for the most common operations. You will be interacting with `kubectl` via the terminal in the assessment.

## Steps

1.  **Enable Kubernetes:**
    * Ensure Kubernetes is enabled in your Docker Desktop settings (or start Minikube).

2.  **Create Manifests:**
    * Create a `deployment.yaml` file for your `python-api:latest` image.
    * Create a `service.yaml` file to expose the deployment. Use type `NodePort` for easy local access.

3.  **Apply & Inspect:**
    * Apply the manifests: `kubectl apply -f deployment.yaml -f service.yaml`
    * **Practice the core commands repeatedly.** This is the most important part.

## Core `kubectl` Commands to Practice

```bash
# Check the status of your app's pods
kubectl get pods
kubectl get pods -w # (to watch for changes)

# Check the status of your service
kubectl get services

# Get detailed information about a specific pod (great for debugging)
kubectl describe pod <your-pod-name>

# Check the application logs from a running pod
kubectl logs <your-pod-name>
kubectl logs -f <your-pod-name> # (to follow the logs in real-time)

# Open a shell inside your running container (critical for debugging)
kubectl exec -it <your-pod-name> -- /bin/sh

# Change the number of running pods
kubectl scale deployment python-api-deployment --replicas=3

# Clean up
kubectl delete -f deployment.yaml -f service.yaml

Repeat:

Repeat steps 2-3 for your node-api:latest image.
```


## Key Copilot Prompts
* `Generate a Kubernetes Deployment YAML for the image 'python-api:latest'. It should have 3 replicas and expose container port 8000.`

* `Generate a Kubernetes Service YAML of type 'NodePort' to expose the 'python-api-deployment' on port 80, targeting the container's port 8000.`