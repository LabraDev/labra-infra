locals {
  # Use caller override when provided; otherwise derive a predictable name.
  resolved_lock_table_name = coalesce(var.lock_table_name, "${var.name_prefix}-terraform-locks")
}

# Stores Terraform state centrally for collaboration and history.
resource "aws_s3_bucket" "state" {
  bucket        = var.state_bucket_name
  force_destroy = var.force_destroy
  tags = merge(var.tags, {
    Name    = var.state_bucket_name
    Purpose = "terraform-state"
  })
}

# Enables version history so state can be recovered after mistakes.
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enforces server-side encryption for all stored state objects.
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Blocks all forms of public access to protect sensitive state content.
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Provides a distributed lock so concurrent Terraform applies are safe.
resource "aws_dynamodb_table" "locks" {
  name         = local.resolved_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  # Terraform's S3 backend expects this exact key name.
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, {
    Name    = local.resolved_lock_table_name
    Purpose = "terraform-locks"
  })
}
