# Exercise 1: Python App + Containerization

**Goal:** Create a simple Python backend API and containerize it. This will be the foundational component for later deployment exercises.

**Why:** The job description mentions Python as a key language. This exercise builds the "component" we will use and practices the first step of any cloud-native workflow: containerization.

## Steps

1.  **Create Project:**
    * Make a new directory (e.g., `python-api`).
    * `cd` into it.

2.  **Generate Application:**
    * Use Copilot to generate a simple **FastAPI** application. (FastAPI is a modern choice, aligning with the "modern backend frameworks" in the job description).
    * Create a `main.py` file for this.
    * Create a `requirements.txt` file listing `fastapi` and `uvicorn`.

3.  **Generate Dockerfile:**
    * Use Copilot to generate a multi-stage `Dockerfile`. This is a best practice for creating slim, secure production images.

4.  **Build Image:**
    * Build the image locally using the Docker CLI.
    * `docker build -t python-api:latest .`

5.  **Run & Test:**
    * Run the container locally to verify it works.
    * `docker run -p 8000:8000 python-api:latest`
    * Open `http://localhost:8000` in your browser to see the JSON response.

## Key Copilot Prompts

* `"Create a simple Python FastAPI app in 'main.py' with a single endpoint '/' that returns a JSON message: {'hello': 'world'}"`
* `"Create a 'requirements.txt' file for 'fastapi' and 'uvicorn'"`
* `"Generate a multi-stage Dockerfile for this FastAPI application. Use 'python:3.11-slim' as the base and 'uvicorn' to run the app on port 8000."`