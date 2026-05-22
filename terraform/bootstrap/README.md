# terraform/bootstrap/

One-time bootstrap configuration that provisions the **S3 bucket** and **DynamoDB lock table** used as the remote backend for every other Terraform configuration in this repo.

## Why a separate config?

Chicken-and-egg: the S3 bucket that stores Terraform state must exist before any Terraform configuration can use it as a backend. This bootstrap config resolves that by:

1. Using **local state** intentionally (its `terraform.tfstate` is gitignored).
2. Creating the bucket and lock table from scratch.
3. Emitting their names as outputs so environments can reference them.

After bootstrap, every other configuration (`environments/dev`, future `environments/prod`, etc.) uses the S3 backend pointing at these resources.

## What gets created

| Resource | Purpose | Notes |
|----------|---------|-------|
| `aws_s3_bucket` | Holds Terraform state files | Versioning enabled, AES256 server-side encryption, all public access blocked |
| `aws_dynamodb_table` | State lock to prevent concurrent applies | `PAY_PER_REQUEST` (cents per month at most) |

Bucket name: `<project>-tfstate-<aws-account-id>` (account ID appended for global uniqueness).

## Usage

```bash
cd terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars   # optional — defaults are fine
terraform init
terraform apply
```

State for this config lives at `./terraform.tfstate` (local, gitignored). **Do not delete it** — if you do, Terraform won't know the bucket exists and will try to recreate it, which AWS will reject. To recover: `terraform import aws_s3_bucket.tfstate <bucket-name>`.

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| `region` | AWS region for the state bucket and lock table | `us-east-1` |
| `project` | Project name prefix | `modern-devops` |

## Outputs

| Name | Description |
|------|-------------|
| `state_bucket` | S3 bucket name — plug into environments' `backend.hcl` |
| `lock_table`   | DynamoDB table name — plug into environments' `backend.hcl` |
| `region`       | Region of the backend resources |
