# terraform/environments/

Per-environment Terraform compositions. Each environment is a fully independent Terraform state — `cd environments/dev && terraform init && terraform apply`.

## Planned

- `dev/` — Smaller node sizes, single-AZ RDS, no Karpenter. The daily-driver environment for testing changes end-to-end.
- `prod/` — Multi-AZ everything, larger nodes, optional Karpenter, manual approval gate in CI.
