# terraform/modules/vpc

Thin wrapper around the community [`terraform-aws-modules/vpc/aws`](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) module, opinionated for EKS:

- Three subnet tiers — **public** (ALB, NAT), **private** (EKS worker nodes), **database** (RDS, isolated route table).
- EKS subnet discovery tags applied so the AWS Load Balancer Controller finds the right subnets automatically.
- Single NAT Gateway by default (cost-optimized for dev). Flip `single_nat_gateway = false` in prod for per-AZ resilience.

## Design choice — why a wrapper, not from scratch?

The community VPC module has thousands of users, encodes AWS networking best practices, and is far better tested than anything we'd hand-roll. Rewriting it is a recognized anti-pattern in production Terraform shops. This wrapper exists to (1) pin a known-good version, (2) set sensible defaults, and (3) apply the EKS-specific subnet tags consistently.

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `project` | Project name prefix (used in VPC name) | `string` | yes |
| `environment` | Environment suffix (e.g. `dev`) | `string` | yes |
| `vpc_cidr` | VPC CIDR block | `string` | no — default `10.0.0.0/16` |
| `availability_zones` | AZs to spread subnets across | `list(string)` | yes |
| `public_subnets` | CIDR blocks for public subnets | `list(string)` | yes |
| `private_subnets` | CIDR blocks for private subnets | `list(string)` | yes |
| `database_subnets` | CIDR blocks for DB subnets | `list(string)` | yes |
| `single_nat_gateway` | Share one NAT vs per-AZ | `bool` | no — default `true` |
| `eks_cluster_name` | EKS cluster name (subnet tagging) | `string` | yes |
| `tags` | Tags applied to all resources | `map(string)` | no — default `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | ID of the VPC |
| `vpc_cidr_block` | CIDR block of the VPC |
| `public_subnet_ids` | IDs of public subnets |
| `private_subnet_ids` | IDs of private subnets (EKS nodes) |
| `database_subnet_ids` | IDs of DB subnets |
| `database_subnet_group_name` | DB subnet group name (passes directly to `aws_db_instance`) |
