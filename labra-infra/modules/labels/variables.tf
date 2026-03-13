# Project name (example: labra-infra).
variable "project_name" {
  description = "Project identifier used in names and tags."
  type        = string
}

# Environment label (example: dev, staging, prod).
variable "environment" {
  description = "Environment identifier."
  type        = string
}

# Optional component suffix to separate module/resource groups.
variable "component" {
  description = "Optional component suffix for resource names."
  type        = string
  default     = ""
}

# Owner/ tag value.
variable "owner" {
  description = "Owner/ responsible for this stack."
  type        = string
}

# Additional tag values merged with module defaults.
variable "extra_tags" {
  description = "Optional additional tags."
  type        = map(string)
  default     = {}
}

# Roadmap tags keep AWS resources traceable to the doc milestone we implemented.
variable "roadmap_phase" {
  description = "Roadmap phase label for tagging."
  type        = string
  default     = "Phase 4"
}

variable "roadmap_version" {
  description = "Roadmap version label for tagging."
  type        = string
  default     = "Ver 1.0"
}
