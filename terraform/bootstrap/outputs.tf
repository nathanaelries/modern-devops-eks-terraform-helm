output "state_bucket" {
  description = "Name of the S3 bucket storing Terraform state for all environments."
  value       = aws_s3_bucket.tfstate.id
}

output "lock_table" {
  description = "Name of the DynamoDB table providing state locking for all environments."
  value       = aws_dynamodb_table.tfstate_lock.id
}

output "region" {
  description = "Region where the backend resources live."
  value       = var.region
}
