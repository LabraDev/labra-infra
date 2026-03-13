# Project identifier used to namespace resources.
variable "project_name" {
  description = "Short project name used in resource naming."
  type        = string
  default     = "labra-infra"
}

# Environment identifier (dev/staging/prod/shared).
variable "environment" {
  description = "Environment label used in names/tags."
  type        = string
  default     = "shared"
}

# AWS region to target for deployments from this root context.
variable "aws_region" {
  description = "AWS region for provider operations."
  type        = string
  default     = "us-west-2"
}

# Primary owner tag for accountability and filtering.
variable "owner" {
  description = "Owner tag."
  type        = string
  default     = "cpsc465"
}

# Additional tags merged into the common tag set.
variable "extra_tags" {
  description = "Optional extra tags to merge into common tags."
  type        = map(string)
  default     = {}
}

# Documentation roadmap markers.
variable "roadmap_phase" {
  description = "Roadmap phase tag used for shared resources."
  type        = string
  default     = "Phase 4"
}

variable "roadmap_version" {
  description = "Roadmap version tag used for shared resources."
  type        = string
  default     = "Ver 1.0"
}
