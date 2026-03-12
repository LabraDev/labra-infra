# Prefix used in names/tags.
variable "name_prefix" {
  description = "Prefix used to name security resources."
  type        = string
}

# VPC where security groups are created.
variable "vpc_id" {
  description = "VPC ID for security group placement."
  type        = string
}

# Port exposed by the application container behind the ALB.
variable "app_port" {
  description = "Application listener port for app security group ingress."
  type        = number
  default     = 8080
}

# Shared tags.
variable "tags" {
  description = "Tags applied to security and IAM resources."
  type        = map(string)
  default     = {}
}
