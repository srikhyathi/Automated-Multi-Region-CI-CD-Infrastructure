# Automated Multi-Region CI/CD & Infrastructure Deployment

[![AWS](https://img.shields.io/badge/AWS-EKS%20%7C%20VPC%20%7C%20ECR-orange.svg)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-blueviolet.svg)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-Multi--Stage-blue.svg)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-RollingUpdate-326CE5.svg)](https://kubernetes.io/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF.svg)](https://github.com/features/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview
This repository implements an automated, production-grade DevOps and Infrastructure as Code (IaC) pipeline designed for multi-region high availability and zero-downtime application releases on AWS.

The solution provisions VPCs and Amazon EKS clusters across primary (`us-east-1`) and secondary (`eu-central-1`) regions using modular Terraform, containerizes Python microservices with multi-stage Docker builds, and orchestrates rolling updates via GitHub Actions.

---

## Architectural Highlights
- **Multi-Region Infrastructure**: Modular Terraform provisions isolated Virtual Private Clouds (VPCs) with public and private subnets, NAT Gateways, and EKS clusters in distinct geographic AWS regions.
- **Zero-Downtime Deployment**: Kubernetes `RollingUpdate` deployment strategy configured with `maxSurge: 1` and `maxUnavailable: 0` alongside fine-tuned `livenessProbe` and `readinessProbe` health checks.
- **Automated CI/CD Pipeline**: GitHub Actions workflow automates syntax verification, Docker container builds, security scans, and continuous deployment synchronization across clusters.
- **Observability**: Exposes native Prometheus metrics at `/metrics` and status health probes at `/healthz` and `/readyz`.

---

## Repository Structure
```
├── app/
│   ├── main.py              # FastAPI microservice with health probes and Prometheus metrics
│   ├── Dockerfile           # Secure multi-stage unprivileged non-root container build
│   └── requirements.txt     # Python runtime dependencies
├── terraform/
│   ├── main.tf              # Multi-region root orchestration
│   ├── providers.tf         # Multi-provider configuration (primary and secondary AWS regions)
│   ├── variables.tf         # Parameterized network CIDRs, cluster names, and environment
│   └── modules/
│       ├── vpc/             # VPC, subnets, route tables, and gateways
│       └── eks/             # Amazon EKS cluster and IAM role definitions
├── k8s/
│   └── deployment.yaml      # Kubernetes manifests with zero-downtime rolling update strategy
└── .github/
    └── workflows/
        └── deploy.yml       # Automated CI/CD pipeline definition
```

---

## Deployment Instructions

### 1. Provision Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 2. Container Build & Local Test
```bash
cd ../app
docker build -t cloud-service-api:local .
docker run -p 8000:8000 cloud-service-api:local
curl http://localhost:8000/healthz
```

### 3. Deploy to Kubernetes
```bash
kubectl apply -f ../k8s/deployment.yaml
kubectl rollout status deployment/cloud-service-api
```

---

## Author
**Sri Khyathi Ambadipudi**  
- GitHub: [@srikhyathi](https://github.com/srikhyathi)  
- LinkedIn: [linkedin.com/in/sri-khyathi](https://linkedin.com/in/sri-khyathi)
