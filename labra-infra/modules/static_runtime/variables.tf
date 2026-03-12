# Prefix used for naming static runtime resources.
variable "name_prefix" {
  description = "Prefix used to name static hosting resources."
  type        = string
}

# Logical app identity used in tags and contract outputs.
variable "app_name" {
  description = "Logical app name for static deploy resources."
  type        = string
}

# Optional override for static site bucket name.
# If null, module derives a deterministic bucket name from prefix + account id.
variable "bucket_name" {
  description = "Optional explicit bucket name for static site assets."
  type        = string
  default     = null
}

variable "default_root_object" {
  description = "Default object served by CloudFront."
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class for cost control."
  type        = string
  default     = "PriceClass_100"
}

variable "enable_spa_routing" {
  description = "Whether 403/404 should resolve to index.html for SPA routing."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Whether static bucket objects can be force-deleted with terraform destroy."
  type        = bool
  default     = false
}

# Release/versioning contract fields.
variable "release_prefix" {
  description = "S3 prefix where per-release artifacts are stored."
  type        = string
  default     = "releases/"
}

variable "current_release_pointer_key" {
  description = "Pointer object key used by backend rollback logic."
  type        = string
  default     = "releases/current.json"
}

variable "release_retention_days" {
  description = "Retention in days for current release objects."
  type        = number
  default     = 90
}

variable "noncurrent_retention_days" {
  description = "Retention in days for noncurrent versioned release objects."
  type        = number
  default     = 30
}

# Alarm scaffolding for static path (Phase 4 baseline).
variable "enable_alarms" {
  description = "Create baseline CloudFront alarms for static runtime."
  type        = bool
  default     = true
}

variable "enable_4xx_alarm" {
  description = "Create optional 4xx spike alarm."
  type        = bool
  default     = false
}

variable "alarm_period_seconds" {
  description = "CloudWatch alarm period in seconds."
  type        = number
  default     = 300
}

variable "alarm_evaluation_periods" {
  description = "CloudWatch alarm evaluation periods."
  type        = number
  default     = 1
}

variable "cf_5xx_rate_threshold" {
  description = "CloudFront 5xx error rate threshold (percentage)."
  type        = number
  default     = 1
}

variable "cf_4xx_rate_threshold" {
  description = "CloudFront 4xx error rate threshold (percentage)."
  type        = number
  default     = 5
}

variable "tags" {
  description = "Tags applied to static runtime resources."
  type        = map(string)
  default     = {}
}
