import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root_endpoint():
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "online"
    assert "uptime_seconds" in data
    assert "region" in data

def test_healthz_endpoint():
    response = client.get("/healthz")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "timestamp" in data

def test_readyz_endpoint():
    response = client.get("/readyz")
    assert response.status_code == 200
    data = response.json()
    assert data["ready"] is True

def test_metrics_endpoint():
    response = client.get("/metrics")
    assert response.status_code == 200
    assert "service_uptime_seconds" in response.text
    assert "service_healthy" in response.text
