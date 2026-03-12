terraform {
  # Keep Terraform version aligned with root-level constraints.
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # We stay on local state until bootstrap finishes.
  # Team note: after bootstrap, re-init with backend.hcl so we all share state.
}

locals {
  # Default tags from variables so provider config is stable at init/plan time.
  provider_default_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      Owner       = var.owner
      ManagedBy   = "Terraform"
      # Frontend/backend team: if an output looks off, check this tag in AWS first.
      # It tells you exactly which roadmap milestone created the resource.
      Version      = var.roadmap_version
      RoadmapPhase = var.roadmap_phase
    },
    var.extra_tags
  )
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.provider_default_tags
  }
}

# Shared naming/tags for every module in this env.
# Backend/frontend team: output keys are based on this prefix, so keep references
# stable if you wire anything to resource names.
module "labels" {
  source = "../../modules/labels"

  project_name    = var.project_name
  environment     = var.environment
  component       = var.component
  owner           = var.owner
  extra_tags      = var.extra_tags
  roadmap_phase   = var.roadmap_phase
  roadmap_version = var.roadmap_version
}

# One-time remote-state bootstrap (S3 + DynamoDB lock table).
# Keep this false for normal applies once backend is configured.
module "state_bootstrap" {
  count  = var.bootstrap_state_backend ? 1 : 0
  source = "../../modules/state-bootstrap"

  name_prefix       = module.labels.resource_prefix
  state_bucket_name = var.state_bucket_name
  lock_table_name   = var.state_lock_table_name
  force_destroy     = var.state_bucket_force_destroy
  tags              = module.labels.tags
}

# Network baseline: VPC, subnets, routing, optional NAT.
# Backend team: worker/runtime design later still depends on this split.
module "network" {
  source = "../../modules/network"

  name_prefix          = module.labels.resource_prefix
  vpc_cidr             = var.vpc_cidr
  az_count             = var.az_count
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = module.labels.tags
}

# Security baseline (Phase 0/1): SG layering + IAM role sketch.
# Backend team: these role outputs remain the trust/policy baseline.
module "security" {
  source = "../../modules/security"

  name_prefix = module.labels.resource_prefix
  vpc_id      = module.network.vpc_id
  app_port    = var.app_port
  tags        = module.labels.tags
}

# Phase 3/4 static deploy baseline: S3 + CloudFront + basic alarm scaffolding.
# Backend team: deploy artifacts should land under `static_release_prefix`.
# Frontend team: `static_site_url` is the URL for the deploy success state.
module "static_runtime" {
  source = "../../modules/static_runtime"

  name_prefix                 = module.labels.resource_prefix
  app_name                    = var.app_name
  bucket_name                 = var.static_site_bucket_name
  default_root_object         = var.static_default_root_object
  price_class                 = var.static_price_class
  enable_spa_routing          = var.static_enable_spa_routing
  force_destroy               = var.static_force_destroy
  release_prefix              = var.static_release_prefix
  current_release_pointer_key = var.static_current_release_pointer_key
  release_retention_days      = var.static_release_retention_days
  noncurrent_retention_days   = var.static_noncurrent_retention_days
  enable_alarms               = var.static_enable_alarms
  enable_4xx_alarm            = var.static_enable_4xx_alarm
  alarm_period_seconds        = var.static_alarm_period_seconds
  alarm_evaluation_periods    = var.static_alarm_evaluation_periods
  cf_5xx_rate_threshold       = var.static_cf_5xx_rate_threshold
  cf_4xx_rate_threshold       = var.static_cf_4xx_rate_threshold
  tags                        = module.labels.tags
}
