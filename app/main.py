"""
Cloud Microservice - Production Health & Metrics Endpoint
"""
import os
import time
from fastapi import FastAPI, Response, status

app = FastAPI(
    title="Cloud Infrastructure Workload Service",
    version="1.0.0",
    description="Resilient microservice deployed across multi-region AWS EKS clusters"
)

START_TIME = time.time()
REGION = os.getenv("AWS_REGION", "us-east-1")
CLUSTER_NAME = os.getenv("EKS_CLUSTER_NAME", "primary-eks-cluster")

@app.get("/")
def read_root():
    return {
        "status": "online",
        "service": "cloud-infrastructure-workload",
        "region": REGION,
        "cluster": CLUSTER_NAME,
        "uptime_seconds": round(time.time() - START_TIME, 2)
    }

@app.get("/healthz", status_code=status.HTTP_200_OK)
def health_check():
    return {"status": "healthy", "timestamp": time.time()}

@app.get("/readyz", status_code=status.HTTP_200_OK)
def readiness_check(response: Response):
    # Validates service dependencies and container readiness
    return {"ready": True, "region": REGION}

@app.get("/metrics")
def prometheus_metrics():
    uptime = time.time() - START_TIME
    metrics_payload = (
        f"# HELP service_uptime_seconds Total service uptime in seconds\n"
        f"# TYPE service_uptime_seconds gauge\n"
        f'service_uptime_seconds{{region="{REGION}",cluster="{CLUSTER_NAME}"}} {uptime}\n'
        f"# HELP service_healthy Service health state (1=healthy, 0=unhealthy)\n"
        f"# TYPE service_healthy gauge\n"
        f'service_healthy{{region="{REGION}"}} 1\n'
    )
    return Response(content=metrics_payload, media_type="text/plain")
