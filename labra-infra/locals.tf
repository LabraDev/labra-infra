locals {
  # Shared prefix that child modules can reuse for naming consistency.
  name_prefix = "${var.project_name}-${var.environment}"

  # Tag baseline applied across all resources.
  common_tags = merge(
    {
      Project      = var.project_name
      Environment  = var.environment
      Owner        = var.owner
      ManagedBy    = "Terraform"
      Version      = var.roadmap_version
      RoadmapPhase = var.roadmap_phase
    },
    var.extra_tags
  )
}
