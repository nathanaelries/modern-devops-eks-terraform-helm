# terraform/modules/

Reusable Terraform modules. Each module exposes a tight `variables.tf` interface and emits useful `outputs.tf` so environments can compose modules without leaking implementation details.

## Planned modules

| Module | Purpose | Status |
|--------|---------|--------|
| [`vpc/`](vpc/) | VPC with public/private/DB subnets across 3 AZs | Phase 1 — Done |
| `eks/` | EKS cluster wrapping `terraform-aws-modules/eks` + add-ons | Phase 2 — Pending |
| `rds/` | RDS PostgreSQL with secure VPC connectivity | Phase 2 — Pending |
| `ecr/` | ECR repository with lifecycle policy | Phase 2 — Pending |
| `iam/` | IRSA roles for in-cluster workloads | Phase 2 — Pending |
