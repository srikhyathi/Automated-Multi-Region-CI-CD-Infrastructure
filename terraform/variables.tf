variable "environment" {
  type        = string
  default     = "production"
  description = "Target deployment environment"
}

variable "primary_region" {
  type        = string
  default     = "us-east-1"
  description = "Primary AWS region for active workload"
}

variable "secondary_region" {
  type        = string
  default     = "eu-central-1"
  description = "Secondary AWS region for disaster recovery and cross-region resilience"
}

variable "primary_vpc_cidr" {
  type        = string
  default     = "10.100.0.0/16"
}

variable "secondary_vpc_cidr" {
  type        = string
  default     = "10.200.0.0/16"
}
