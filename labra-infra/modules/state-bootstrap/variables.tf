# Prefix for generated naming conventions.
variable "name_prefix" {
  description = "Name prefix used for tagging and defaults."
  type        = string
}

# S3 bucket name for Terraform state (must be globally unique in AWS).
variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

# Optional explicit DynamoDB lock table name.
variable "lock_table_name" {
  description = "Optional lock table name; defaults to <name_prefix>-terraform-locks."
  type        = string
  default     = null
}

# Keep false in most environments to avoid accidental state loss.
variable "force_destroy" {
  description = "Whether the S3 state bucket can be destroyed even if non-empty."
  type        = bool
  default     = false
}

# Shared tags passed from calling stack.
variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
