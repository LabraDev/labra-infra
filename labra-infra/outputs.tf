# Useful root outputs for quick inspection/testing of naming/tag behavior.
output "name_prefix" {
  description = "Computed global prefix used for names."
  value       = local.name_prefix
}

output "common_tags" {
  description = "Computed global tags merged from defaults and extra_tags."
  value       = local.common_tags
}
