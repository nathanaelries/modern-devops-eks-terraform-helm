# helm-charts/

Helm charts deployed onto the EKS cluster.

- [`my-app/`](my-app/) — Custom chart for the sample document-processing application (Phase 4).
- [`monitoring/`](monitoring/) — Prometheus + Grafana stack (Phase 6, optional).

Charts are rendered and deployed from CI/CD via `helm upgrade --install` after Terraform has provisioned the cluster.
