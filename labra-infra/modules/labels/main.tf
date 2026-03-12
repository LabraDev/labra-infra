locals {
  # Add a dash only when component is provided so names stay clean.
  component_suffix = var.component != "" ? "-${var.component}" : ""

  # Canonical prefix shared by resources in this stack/component.
  resource_prefix = "${var.project_name}-${var.environment}${local.component_suffix}"

  # Base tag set expected on all managed resources.
  base_tags = {
    Project      = var.project_name
    Environment  = var.environment
    Owner        = var.owner
    ManagedBy    = "Terraform"
    Version      = var.roadmap_version
    RoadmapPhase = var.roadmap_phase
  }

  # Final tags after merging optional custom values.
  tags = merge(local.base_tags, var.extra_tags)
}
