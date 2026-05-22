# Contributing

This is primarily a personal portfolio project, but suggestions, issues, and PRs are welcome.

## Reporting Issues

If you spot a bug, security concern, or have a suggestion, please [open an issue](../../issues) with a clear description and (if relevant) reproduction steps.

## Pull Requests

1. Fork the repo and create a feature branch off `main`.
2. Keep PRs focused — one logical change per PR.
3. For Terraform changes, run `terraform fmt -recursive` and `terraform validate` locally before pushing.
4. For application changes, ensure the Dockerfile builds cleanly and any tests pass.
5. Open a PR describing the *why* of the change, not just the *what*.

## Code Style

- **Terraform**: standard `terraform fmt` style. Document module inputs/outputs.
- **Node.js**: Prettier defaults.
- **Commit messages**: imperative mood (`Add VPC module`, not `Added VPC module`).

## License

By contributing, you agree your contributions will be licensed under the [MIT License](LICENSE).
