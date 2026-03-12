# Core identifiers.
project_name    = "labra-infra"
environment     = "dev"
component       = "platform"
owner           = "cpsc465-infra"
aws_region      = "us-west-2"
roadmap_phase   = "Phase 4"
roadmap_version = "Ver 1.0"

# Extra tags for course/project filtering.
extra_tags = {
  Course = "CPSC465"
  Scope  = "Infrastructure"
}

# Backend bootstrap defaults.
# Set true only for the one-time backend creation apply.
bootstrap_state_backend = false

# Must be globally unique in AWS S3.
state_bucket_name          = "replace-me-labra-infra-dev-tfstate"
state_lock_table_name      = "labra-infra-dev-platform-terraform-locks"
state_bucket_force_destroy = false

# Foundation network baseline.
vpc_cidr             = "10.20.0.0/16"
az_count             = 2
public_subnet_cidrs  = ["10.20.0.0/24", "10.20.1.0/24"]
private_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]
enable_nat_gateway   = true

# App metadata contracts.
app_port   = 8080
app_name   = "demo-app"
build_type = "static"

# Phase 3/4 static path defaults.
static_site_bucket_name            = null
static_default_root_object         = "index.html"
static_enable_spa_routing          = true
static_price_class                 = "PriceClass_100"
static_force_destroy               = false
static_release_prefix              = "releases/"
static_current_release_pointer_key = "releases/current.json"
static_release_retention_days      = 90
static_noncurrent_retention_days   = 30
static_enable_alarms               = true
static_enable_4xx_alarm            = false
static_alarm_period_seconds        = 300
static_alarm_evaluation_periods    = 1
static_cf_5xx_rate_threshold       = 1
static_cf_4xx_rate_threshold       = 5
