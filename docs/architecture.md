# Architecture

This document expands on the top-level diagram in the [README](../README.md) with component-specific views and design rationale.

## Network Topology

```mermaid
flowchart TB
    Internet([Internet])
    Internet --> IGW[Internet Gateway]

    subgraph VPC [VPC - 10.0.0.0/16]
        IGW
        subgraph Public [Public Subnets - 3 AZs]
            ALB[ALB]
            NAT[NAT Gateway]
        end
        IGW --> ALB
        IGW --> NAT
        subgraph Private [Private Subnets - 3 AZs]
            Nodes[EKS Managed Node Group]
        end
        ALB --> Nodes
        Nodes --> NAT
        subgraph DBNet [DB Subnets - 3 AZs]
            RDS[(RDS PostgreSQL)]
        end
        Nodes --> RDS
    end
```

**Rationale:**
- Three Availability Zones for high availability without overpaying for cross-AZ traffic in a demo.
- Worker nodes live in private subnets; only the ALB is internet-facing.
- DB subnets are isolated from worker subnets by separate route tables — defense in depth.
- A single NAT Gateway is used by default (cost optimization); production environments can switch to one-per-AZ via a variable.

## CI/CD Flow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant AWS as AWS STS (OIDC)
    participant ECR
    participant EKS

    Dev->>GH: Push to feature branch
    GH->>GHA: Trigger workflow
    GHA->>GHA: terraform fmt / validate / tflint
    GHA->>AWS: AssumeRoleWithWebIdentity (OIDC)
    AWS-->>GHA: Temporary credentials (15 min)
    GHA->>AWS: terraform plan → comment on PR
    Dev->>GH: Review & merge to main
    GHA->>AWS: terraform apply (dev auto, prod manual approval)
    GHA->>ECR: docker build & push
    GHA->>EKS: helm upgrade --install
    EKS-->>GHA: Rollout status
    GHA->>GH: Update commit status
```

**Why OIDC:** No long-lived AWS access keys live in GitHub secrets. The workflow trades a short-lived OIDC token for temporary STS credentials scoped to a specific IAM role with least-privilege policies. This is the AWS-recommended pattern for CI/CD and removes an entire class of credential-leak risk.

## IRSA (IAM Roles for Service Accounts)

```mermaid
flowchart LR
    Pod[App Pod] -->|uses| SA[ServiceAccount<br/>app-sa]
    SA -->|annotation:<br/>eks.amazonaws.com/role-arn| IAMRole[IAM Role]
    IAMRole -->|policy: s3:PutObject| S3[(S3 Bucket)]
    Pod -.->|projected SA token| OIDC[EKS OIDC Provider]
    OIDC -.->|trust relationship| IAMRole
```

**Rationale:** Pods receive scoped AWS credentials without sharing the node IAM role or mounting long-lived keys. The app pod can only assume the IAM role needed to write a document to S3 — the database connection still goes through a Kubernetes Secret because RDS uses native PostgreSQL auth.

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Multi-env strategy | Separate `environments/dev` + `environments/prod` directories | Clearer blast radius vs Terraform workspaces; easier to diff plans per environment |
| EKS module | `terraform-aws-modules/eks` | Well-maintained, encodes AWS best practices, far less code than rolling our own |
| Node scaling | Managed node groups first, Karpenter as Phase 7 upgrade | Managed groups are simpler to reason about; Karpenter is shown as an evolution, not a starting point |
| Database | RDS PostgreSQL (not in-cluster) | Managed backups, automated minor version upgrades, simpler RPO/RTO story |
| Container registry | ECR (private) | Native IAM auth — no separate credential management |
| Ingress | AWS Load Balancer Controller (ALB) | Native ALB integration; cheaper than NLB-per-service for HTTP workloads |
| State backend | S3 + DynamoDB | Industry standard; DynamoDB lock prevents concurrent applies |
| Secrets | Kubernetes Secrets + External Secrets Operator (Phase 6+) | Start simple, migrate to AWS Secrets Manager when the demo justifies it |
