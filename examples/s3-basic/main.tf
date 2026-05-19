// examples/s3-basic/main.tf

provider "aws" {
  region = "eu-central-1"
}

# S3 Module
module "s3" {
  source = "../../"

  bucket_name = var.bucket_name

  # Security Configuration
  versioning_enabled      = var.versioning_enabled
  kms_key_id              = var.kms_key_id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  # Lifecycle Configuration
  lifecycle_rules = var.lifecycle_rules

  # Website Configuration
  enable_website = var.enable_website
  index_document = var.index_document
  error_document = var.error_document
  routing_rules  = var.routing_rules

  # CORS Configuration
  cors_rules = var.cors_rules

  # Logging Configuration
  enable_logging        = var.enable_logging
  logging_target_bucket = var.logging_target_bucket
  logging_target_prefix = var.logging_target_prefix

  # Notifications
  enable_notifications = var.enable_notifications
  lambda_notifications = var.lambda_notifications
  sns_notifications    = var.sns_notifications

  # Bucket Policy
  bucket_policy = var.bucket_policy

  tags = var.tags
}
