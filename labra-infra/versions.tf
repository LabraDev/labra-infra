terraform {
  # Pin Terraform to a modern version that supports current AWS provider features.
  required_version = ">= 1.6.0"

  # Lock provider sources/versions for reproducible plans across machines.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
