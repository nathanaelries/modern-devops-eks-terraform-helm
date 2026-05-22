variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name prefix."
  type        = string
  default     = "modern-devops"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets (3 AZs)."
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets (3 AZs, EKS nodes)."
  type        = list(string)
  default     = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}

variable "database_subnets" {
  description = "CIDR blocks for DB subnets (3 AZs)."
  type        = list(string)
  default     = ["10.0.96.0/24", "10.0.97.0/24", "10.0.98.0/24"]
}

variable "eks_cluster_name" {
  description = "EKS cluster name (used to tag subnets for AWS Load Balancer Controller discovery). The cluster itself is provisioned in Phase 2."
  type        = string
  default     = "modern-devops-dev"
}
