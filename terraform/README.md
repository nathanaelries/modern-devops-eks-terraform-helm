# terraform/

Root Terraform configuration and reusable modules for provisioning the AWS infrastructure.

## Layout

- [`modules/`](modules/) — Reusable, composable modules (`vpc/`, `eks/`, `rds/`, `ecr/`, `iam/`).
- [`environments/`](environments/) — Per-environment compositions (`dev/`, `prod/`) that call the modules with environment-specific sizing.

State is stored remotely in S3 with DynamoDB locking. The bootstrap procedure (creating the state bucket and lock table) lands in Phase 1 — see [docs/architecture.md](../docs/architecture.md).

## Status

Phase 1 (Terraform foundation) is the next slice. This directory is currently a scaffold.
