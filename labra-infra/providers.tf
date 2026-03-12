# Root provider config for shared defaults/examples.
# Real deployments happen in env/dev, but these defaults keep root consistent.
provider "aws" {
  region = var.aws_region

  # Apply common tags to all AWS resources created from this root context.
  default_tags {
    tags = local.common_tags
  }
}
