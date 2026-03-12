# Quick naming/tag outputs so everyone can confirm we are on the same env.
output "resource_prefix" {
  description = "Computed name prefix used by the environment modules."
  value       = module.labels.resource_prefix
}

output "tags" {
  description = "Merged tags used in this environment."
  value       = module.labels.tags
}

# Backend/frontend team: use these values first when comparing state and logs.
output "roadmap_phase" {
  description = "Roadmap phase marker for this environment."
  value       = var.roadmap_phase
}

output "roadmap_version" {
  description = "Roadmap version marker for this environment."
  value       = var.roadmap_version
}

# App metadata contract (Phase 2).
output "app_name" {
  description = "Logical app name configured for this environment."
  value       = var.app_name
}

output "build_type" {
  description = "Configured build/deploy type for this environment."
  value       = var.build_type
}

# Remote-state outputs are optional because bootstrap can be turned off.
output "state_bucket_name" {
  description = "Terraform state bucket name when bootstrap_state_backend=true."
  value       = try(module.state_bootstrap[0].state_bucket_name, null)
}

output "state_lock_table_name" {
  description = "Terraform lock table name when bootstrap_state_backend=true."
  value       = try(module.state_bootstrap[0].lock_table_name, null)
}

# Network outputs consumed by deployment/runtime layers.
output "vpc_id" {
  description = "VPC ID for this environment."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnets for internet-facing resources."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnets for app/runtime resources."
  value       = module.network.private_subnet_ids
}

output "nat_gateway_id" {
  description = "NAT gateway ID when enabled."
  value       = module.network.nat_gateway_id
}

# Security outputs (Phase 0/1 baseline).
output "alb_security_group_id" {
  description = "Security group ID for ALB resources."
  value       = module.security.alb_security_group_id
}

output "app_security_group_id" {
  description = "Security group ID for app runtime resources."
  value       = module.security.app_security_group_id
}

output "build_role_arn" {
  description = "IAM role ARN for build worker baseline."
  value       = module.security.build_role_arn
}

output "deploy_role_arn" {
  description = "IAM role ARN for deploy worker baseline."
  value       = module.security.deploy_role_arn
}

# Static deploy outputs (Phase 3/4 baseline).
# Backend team: deploy flow writes artifacts + invalidates this distribution.
# Frontend team: `static_site_url` is the URL to render after successful deploy.
output "static_bucket_name" {
  description = "S3 bucket name for static deploy artifacts."
  value       = module.static_runtime.bucket_name
}

output "static_distribution_id" {
  description = "CloudFront distribution ID for static deploy path."
  value       = module.static_runtime.distribution_id
}

output "static_site_url" {
  description = "Public URL for static deploy mode."
  value       = module.static_runtime.site_url
}

output "static_release_prefix" {
  description = "Release artifact prefix used by static deploy flow."
  value       = module.static_runtime.release_prefix
}

output "static_current_release_pointer_key" {
  description = "Pointer key backend can update during release updates."
  value       = module.static_runtime.current_release_pointer_key
}

output "static_alarm_names" {
  description = "CloudFront alarm names for static runtime."
  value       = module.static_runtime.alarm_names
}
