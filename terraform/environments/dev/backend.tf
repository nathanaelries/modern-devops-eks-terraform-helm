# Partial backend config. Initialize with:
#   terraform init -backend-config=backend.hcl
# See backend.hcl.example for the keys to set.
terraform {
  backend "s3" {}
}
