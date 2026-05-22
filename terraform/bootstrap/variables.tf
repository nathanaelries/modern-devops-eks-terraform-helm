variable "region" {
  description = "AWS region for the state bucket and lock table."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name prefix for the state bucket and lock table."
  type        = string
  default     = "modern-devops"
}
