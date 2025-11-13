from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"message": "Hello World"}


@app.get("/health")
def health_check():
    """
    Liveness probe endpoint.
    Returns healthy if the application process is running and responsive.
    Does not check external dependencies.
    """
    return {"status": "healthy"}


@app.get("/ready")
def readiness_check():
    """
    Readiness probe endpoint.
    Returns ready if the application is ready to handle traffic.
    In production, this would check external dependencies like databases.
    """
    # In a real app, you'd check:
    # - Database connectivity
    # - Cache availability
    # - Required external services
    return {"status": "ready"}
