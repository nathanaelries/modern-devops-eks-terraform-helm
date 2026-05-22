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
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "IDs of the private subnets (where EKS nodes run)."
  value       = module.vpc.private_subnets
}

output "database_subnet_ids" {
  description = "IDs of the database subnets (where RDS will run in Phase 2)."
  value       = module.vpc.database_subnets
}

output "database_subnet_group_name" {
  description = "Name of the DB subnet group, ready to pass to aws_db_instance."
  value       = module.vpc.database_subnet_group_name
}
