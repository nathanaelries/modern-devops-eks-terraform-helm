output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets (EKS nodes will land here in Phase 2)."
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs of the database subnets (RDS will land here in Phase 2)."
  value       = module.vpc.database_subnet_ids
}

output "database_subnet_group_name" {
  description = "Name of the DB subnet group."
  value       = module.vpc.database_subnet_group_name
}
