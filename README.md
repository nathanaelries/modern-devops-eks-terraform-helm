# modern-devops-eks-terraform-helm

[![Status](https://img.shields.io/badge/status-scaffolding-yellow)]()
[![Terraform](https://img.shields.io/badge/terraform-1.7%2B-7B42BC?logo=terraform)]()
[![AWS](https://img.shields.io/badge/AWS-EKS%20%7C%20RDS%20%7C%20ECR-FF9900?logo=amazon-aws)]()
[![Kubernetes](https://img.shields.io/badge/k8s-helm%203-326CE5?logo=kubernetes)]()
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

End-to-end modern DevOps demonstration: Terraform IaC provisions a secure, scalable AWS EKS cluster (VPC, managed node groups, RDS PostgreSQL, ECR) plus supporting services. Helm charts deploy a sample document-processing application. A full GitHub Actions CI/CD pipeline uses OIDC for keyless AWS authentication. Built to demonstrate production-grade IaC, Kubernetes-native deployments, and modern CI/CD practices.

> **Status (May 2026):** Repository scaffolding in progress. Architecture, design decisions, and roadmap are documented below; implementation lands incrementally in tracked phases. See [Roadmap](#roadmap).

## Architecture

```mermaid
flowchart LR
    Dev([Developer]) -->|git push| GH[GitHub Repo]
    GH -->|OIDC, no static creds| GHA[GitHub Actions]
    GHA -->|terraform plan/apply| TFState[(Terraform State<br/>S3 + DynamoDB)]
    GHA -->|docker build → push| ECR[(ECR)]
    GHA -->|helm upgrade| EKSAPI[EKS API]

    subgraph AWS [AWS Account]
        direction TB
        subgraph VPC [VPC - multi-AZ]
            subgraph EKS [EKS Cluster]
                ALB[ALB Ingress Controller]
                APP[App Pods<br/>Node.js + Express]
                ALB --> APP
            end
            RDS[(RDS<br/>PostgreSQL)]
        end
        ECR
        S3[(S3 Bucket<br/>Documents)]
        APP -->|IRSA| S3
        APP -->|TLS| RDS
        EKSAPI -.->|deploys to| EKS
    end
```

See [docs/architecture.md](docs/architecture.md) for component-level diagrams (network topology, CI/CD flow, IRSA) and design rationale.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| IaC | Terraform 1.7+, `terraform-aws-modules/eks` |
| Cloud | AWS — EKS, VPC, RDS PostgreSQL, ECR, S3, IAM/IRSA |
| Orchestration | Kubernetes (EKS), AWS Load Balancer Controller |
| Packaging | Helm 3 |
| Application | Node.js + Express + PostgreSQL |
| CI/CD | GitHub Actions, AWS OIDC federation |
| Observability | Prometheus + Grafana (optional) |
| State backend | S3 + DynamoDB lock |

## Repository Layout

```
.
├── terraform/                   Terraform root + reusable modules
│   ├── modules/                 vpc, eks, rds, ecr, iam (IRSA)
│   └── environments/            dev/, prod/
├── helm-charts/
│   ├── my-app/                  Document-processing app chart
│   └── monitoring/              Prometheus + Grafana
├── app/                         Node.js + Express sample app
├── .github/workflows/           Terraform & app deployment pipelines
└── docs/                        Architecture diagrams and notes
```

## Roadmap

| Phase | Status | Description |
|-------|--------|-------------|
| 0. Scaffold + README + diagrams | Done | Repo structure, polished README, architecture diagrams, license |
| 1. Terraform foundation | Done | Remote state bootstrap, VPC module, dev environment composition |
| 2. EKS + supporting services | Pending | EKS cluster, managed node groups, ECR, RDS, IAM/IRSA |
| 3. Sample application | Pending | Node.js doc-processing app + Dockerfile |
| 4. Helm chart | Pending | Custom chart for app + ALB Ingress |
| 5. CI/CD pipelines | Pending | GitHub Actions with OIDC (Terraform + app deploy) |
| 6. Observability | Planned | Prometheus + Grafana via Helm |
| 7. Cost & multi-env | Planned | Karpenter, cost tags, prod environment |

## Quick Start

**Prerequisites:** Terraform 1.7+, AWS CLI configured with admin (or equivalent) credentials, an AWS account.

**1. Bootstrap remote state** (one-time per account):

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

Note the `state_bucket` output — you'll reference it in the dev environment's `backend.hcl`.

**2. Provision the dev environment:**

```bash
cd ../environments/dev
cp backend.hcl.example backend.hcl
# Edit backend.hcl: set bucket = "modern-devops-tfstate-<your-account-id>"
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

See [terraform/environments/dev/README.md](terraform/environments/dev/README.md) for details, outputs, and teardown.

## Why This Project?

This repository is a deliberate, resume-grade showcase of skills I exercise daily as a Senior Systems Administrator at Venio Systems and study toward formally with the **HashiCorp Terraform Associate** and **AWS Cloud Practitioner** certifications. It maps directly to my work history:

- **Infrastructure as Code** — Modular Terraform mirrors the IaC-driven environment configuration I do at Venio.
- **Migration from proprietary to open-source / self-hosted** — The sample app reflects experience moving eDiscovery workloads off Relativity / NUIX onto self-hosted infrastructure.
- **CI/CD & build/release automation** — Matches the build/deploy pipelines I own in my current role.
- **AWS fundamentals (VPC, EC2, IAM, PostgreSQL)** — Production-grade application of the AWS primitives I work with day-to-day.

## License

MIT — see [LICENSE](LICENSE).
