# terraform/environments/

Per-environment Terraform compositions. Each environment is a fully independent Terraform state — `cd environments/dev && terraform init && terraform apply`.

## Environments

- [`dev/`](dev/) — **Present** (Phase 1 onward). Smaller node sizes, single NAT, single-AZ RDS (when added in Phase 2), no Karpenter. Daily-driver for testing changes end-to-end.
- `prod/` — Planned. Multi-AZ everything, larger nodes, optional Karpenter, manual approval gate in CI.
