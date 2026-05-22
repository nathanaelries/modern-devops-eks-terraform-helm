# terraform/modules/

Reusable Terraform modules. Each module exposes a tight `variables.tf` interface and emits useful `outputs.tf` so environments can compose modules without leaking implementation details.

## Planned modules

| Module | Purpose | Phase |
|--------|---------|-------|
| `vpc/` | VPC with public/private/DB subnets across 3 AZs | 1 |
| `eks/` | EKS cluster wrapping `terraform-aws-modules/eks` + add-ons | 2 |
| `rds/` | RDS PostgreSQL with secure VPC connectivity | 2 |
| `ecr/` | ECR repository with lifecycle policy | 2 |
| `iam/` | IRSA roles for in-cluster workloads | 2 |
