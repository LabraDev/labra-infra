# Prefix used in Name tags and related identifiers.
variable "name_prefix" {
  description = "Prefix used for naming and tagging."
  type        = string
}

# Top-level CIDR block for the VPC.
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

# Number of availability zones/subnet pairs to create.
variable "az_count" {
  description = "How many AZs to spread subnets across."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 1 && var.az_count <= 3
    error_message = "az_count must be between 1 and 3."
  }
}

# Public subnet CIDRs used for ALB/NAT and internet-routable resources.
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets; must include at least az_count entries."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) >= var.az_count
    error_message = "public_subnet_cidrs must have at least az_count items."
  }
}

# Private subnet CIDRs used for app/runtime resources.
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets; must include at least az_count entries."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) >= var.az_count
    error_message = "private_subnet_cidrs must have at least az_count items."
  }
}

# Toggle NAT creation for outbound access from private subnets.
variable "enable_nat_gateway" {
  description = "Whether to create a single NAT gateway for private subnet egress."
  type        = bool
  default     = true
}

# Shared tags.
variable "tags" {
  description = "Tags applied to resources in this module."
  type        = map(string)
  default     = {}
}
