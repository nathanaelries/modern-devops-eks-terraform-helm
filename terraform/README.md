# terraform/

Root Terraform configuration and reusable modules for provisioning the AWS infrastructure.

## Layout

- [`modules/`](modules/) — Reusable, composable modules (`vpc/`, `eks/`, `rds/`, `ecr/`, `iam/`).
- [`environments/`](environments/) — Per-environment compositions (`dev/`, `prod/`) that call the modules with environment-specific sizing.

State is stored remotely in S3 with DynamoDB locking. The bootstrap procedure (creating the state bucket and lock table) lands in Phase 1 — see [docs/architecture.md](../docs/architecture.md).

## Status

- Phase 1 (foundation): **Done** — [`bootstrap/`](bootstrap/), [`modules/vpc/`](modules/vpc/), and [`environments/dev/`](environments/dev/) are present and applyable.
- Phase 2 (EKS + supporting services): Pending.

See the [top-level Quick Start](../README.md#quick-start) for how to run.
