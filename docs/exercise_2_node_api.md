# Exercise 2: Node.js App + Containerization

**Goal:** Repeat Exercise 1, but with the Node.js stack. This gives you a second, distinct microservice to deploy.

**Why:** The job description explicitly lists **NodeJS (NestJS)** as part of their stack. Your resume also shows extensive experience with Node.js. This demonstrates your versatility across their required languages.

## Steps

1.  **Create Project:**
    * Make a new directory (e.g., `node-api`).
    * `cd` into it.

2.  **Generate Application:**
    * Use Copilot to scaffold a simple **NestJS** application. (NestJS is explicitly mentioned in the job description).
    * You can also use a simple `Express` app if time is critical.

3.  **Generate Dockerfile:**
    * Use Copilot to generate a multi-stage `Dockerfile` for the NestJS app. This will be more complex than the Python one (handling `node_modules`, `package.json`, and build steps).

4.  **Build Image:**
    * Build the image locally.
    * `docker build -t node-api:latest .`

5.  **Run & Test:**
    * Run the container locally to verify.
    * `docker run -p 3000:3000 node-api:latest`
    * Open `http://localhost:3000` in your browser to test.

## Key Copilot Prompts

* `"Scaffold a new NestJS application with a single controller for a '/health' endpoint that returns {'status': 'ok'}"`
* `"Generate a production-ready, multi-stage Dockerfile for this NestJS app. It should handle 'npm install' and 'npm run build' in a builder stage and copy only the 'dist' folder and 'node_modules' to the final image."`