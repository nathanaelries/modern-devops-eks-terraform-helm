# .github/workflows/

GitHub Actions pipelines. Land in Phase 5.

## Planned workflows

- `terraform-ci-cd.yml` — On PR: `fmt`, `validate`, `tflint`, `plan` (commented to PR). On merge to `main`: `apply` to dev (auto) and prod (manual approval gate).
- `app-deploy.yml` — Build Docker image, push to ECR, `helm upgrade` against the appropriate environment.

Both workflows authenticate to AWS via **OIDC federation** — no long-lived `AWS_ACCESS_KEY_ID` secrets stored in GitHub. See [docs/architecture.md](../../docs/architecture.md#cicd-flow) for the auth flow.
