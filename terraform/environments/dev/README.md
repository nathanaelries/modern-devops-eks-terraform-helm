# terraform/environments/dev/

Dev environment composition. Currently provisions the VPC that the dev EKS cluster (Phase 2) will live in.

## Prerequisites

The [bootstrap config](../../bootstrap/) must have been applied — the dev environment's state lives in the S3 bucket and DynamoDB table that bootstrap creates.

## Setup

```bash
# 1. Copy and edit the backend partial config
cp backend.hcl.example backend.hcl
# Edit backend.hcl: replace REPLACE_WITH_ACCOUNT_ID with your AWS account ID

# 2. Initialize with the backend config
terraform init -backend-config=backend.hcl

# 3. Review and apply
terraform plan
terraform apply
```

`backend.hcl` is gitignored — it's account-specific.

## Teardown

```bash
terraform destroy
```

Deletes the VPC and all dependent resources (subnets, NAT, route tables, IGW). Does **not** delete the bootstrap bucket/table — `cd ../../bootstrap && terraform destroy` for a full cleanup.

## What it provisions

Phase 1:
- 1 VPC (`10.0.0.0/16`)
- 3 public subnets (one per AZ)
- 3 private subnets (one per AZ — EKS worker nodes land here)
- 3 database subnets (one per AZ — RDS lands here in Phase 2)
- 1 NAT Gateway (cost-optimized; flip `single_nat_gateway` to false for per-AZ)
- Internet Gateway, route tables, subnet associations

Phase 2 (pending) will add EKS, RDS, ECR, and IAM/IRSA modules here.

## Inputs

All inputs have dev-appropriate defaults — running `terraform apply` with no overrides works out of the box. Override in `terraform.tfvars` if needed.

| Name | Description | Default |
|------|-------------|---------|
| `region` | AWS region | `us-east-1` |
| `project` | Project name | `modern-devops` |
| `environment` | Environment name | `dev` |
| `vpc_cidr` | VPC CIDR | `10.0.0.0/16` |
| `public_subnets` | Public subnet CIDRs | `["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]` |
| `private_subnets` | Private subnet CIDRs | `["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]` |
| `database_subnets` | DB subnet CIDRs | `["10.0.96.0/24", "10.0.97.0/24", "10.0.98.0/24"]` |
| `eks_cluster_name` | EKS cluster name (for subnet tagging) | `modern-devops-dev` |

AZs are auto-discovered via `data.aws_availability_zones` — the first three available AZs in the region are used.

## Outputs

`vpc_id`, `vpc_cidr_block`, `public_subnet_ids`, `private_subnet_ids`, `database_subnet_ids`, `database_subnet_group_name`. Phase 2's EKS and RDS modules will consume these.

## Cost estimate

Phase 1 alone (just the VPC) on us-east-1:
- NAT Gateway: ~$32/mo + data transfer charges
- Everything else: free tier
- **Practical**: roughly $1–5/day if left running.

Run `terraform destroy` between work sessions, or budget accordingly.
