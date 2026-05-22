variable "project" {
  description = "Project name prefix (used in VPC name)."
  type        = string
}

variable "environment" {
  description = "Environment suffix (e.g. 'dev', 'prod') used in VPC name."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across. Length must equal the length of each subnet list."
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets (internet-facing ALB, NAT Gateway)."
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets (EKS worker nodes)."
  type        = list(string)
}

variable "database_subnets" {
  description = "CIDR blocks for database subnets (RDS, isolated route table)."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "If true, share one NAT Gateway across all private subnets (cost-optimized). Set to false in prod for per-AZ NAT."
  type        = bool
  default     = true
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster that will live in this VPC. Used to tag subnets so the AWS Load Balancer Controller can discover them."
  type        = string
}

variable "tags" {
  description = "Tags applied to all VPC resources."
  type        = map(string)
  default     = {}
}
