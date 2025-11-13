# Python API

A simple FastAPI application demonstrating modern Python development and containerization practices.

## Prerequisites

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) - Fast Python package manager
- Docker (for containerization)

## Project Structure

```
python-api/
├── src/
│   └── main.py          # FastAPI application
├── Dockerfile           # Multi-stage production build
├── .dockerignore        # Docker build context exclusions
└── pyproject.toml       # Project metadata and dependencies
```

## Local Development

### Setup

```bash
# Create virtual environment
uv venv

# Install dependencies
uv pip install -e .
```

### Run Locally

```bash
# Run with auto-reload (development mode)
uv run uvicorn src.main:app --reload

# Server runs at http://127.0.0.1:8000
# API docs at http://127.0.0.1:8000/docs
```

### Test the API

```bash
# Root endpoint
curl http://127.0.0.1:8000

# Expected response:
# {"message":"Hello World"}
```

## Docker

### Build Image

```bash
# Build the multi-stage Docker image
docker build -t python-api:latest .

# View image details
docker images python-api

# Inspect image layers
docker history python-api:latest
```

### Run Container

```bash
# Run in foreground
docker run -p 8000:8000 python-api:latest

# Run in background (detached mode)
docker run -d -p 8000:8000 --name my-api python-api:latest

# Run with auto-removal (cleans up after stop)
docker run --rm -p 8000:8000 --name my-api python-api:latest
```

### Manage Containers

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View container logs
docker logs my-api

# Follow logs in real-time
docker logs -f my-api

# See resource usage
docker stats my-api

# Execute command inside container
docker exec my-api ps aux

# Get a shell inside the container
docker exec -it my-api /bin/bash

# Check health status
docker inspect --format='{{.State.Health.Status}}' my-api
```

### Stop & Cleanup

```bash
# Stop container gracefully
docker stop my-api

# Stop and remove
docker rm -f my-api

# Remove image
docker rmi python-api:latest

# Clean up unused resources
docker system prune

# Aggressive cleanup (includes unused images)
docker system prune -a
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Returns hello world message |
| GET | `/docs` | Interactive API documentation (Swagger UI) |
| GET | `/redoc` | Alternative API documentation (ReDoc) |

## Development Notes

### Why `uv`?

- **Fast**: 10-100x faster than pip
- **Modern**: Built in Rust, designed for Python 3.11+
- **Simple**: Replaces pip, virtualenv, and poetry with one tool

### Why Multi-Stage Docker Build?

1. **Smaller images**: Final image only contains runtime dependencies (~150MB vs ~400MB)
2. **Faster builds**: Layers are cached, rebuilds only change when dependencies change
3. **Security**: Build tools and source dependencies stay in builder stage

### Security Features

- **Non-root user**: App runs as `appuser` (not `root`)
- **Minimal base**: `python:3.11-slim` reduces attack surface
- **Health checks**: Container reports actual app health, not just process status

## Troubleshooting

**Port already in use:**
```bash
# Find what's using port 8000
lsof -i :8000

# Use a different port
docker run -p 8080:8000 python-api:latest
```

**Container exits immediately:**
```bash
# Check logs for errors
docker logs my-api

# Run with interactive terminal to see output
docker run -it python-api:latest
```

**Image build fails:**
```bash
# Clear Docker cache and rebuild
docker build --no-cache -t python-api:latest .
```
