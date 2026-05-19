// main.tf
# Written by Marc Straubinger - Overhauled for Security-First Best Practices and Feature Completeness

# S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name != "" ? var.bucket_name : "${local.name_prefix}-bucket"
  force_destroy = var.force_destroy

  # PSA Compliance: Data Integrity
  object_lock_enabled = var.object_lock_enabled

  tags = merge(local.common_tags, {
    "Name"          = var.bucket_name != "" ? var.bucket_name : "${local.name_prefix}-bucket"
    "PSA-Compliant" = "true"
  })
}

# S3 Bucket Versioning
# PSA Compliance: Data Protection
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# S3 Bucket Server-side Encryption
# PSA Compliance: Req 3.50-01 (Approved algorithms)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = var.kms_key_id != "" ? "aws:kms" : "AES256"
    }
    # PSA Compliance: Security & Performance (S3 Bucket Keys)
    bucket_key_enabled = true
  }
}

# S3 Bucket Public Access Block
# PSA Compliance: Default deny public access
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# S3 Bucket Ownership Controls
# PSA Compliance: Modern access control (disable ACLs)
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.object_ownership
  }
}

# S3 Bucket Policy
# PSA Compliance: Enforce SSL and Custom Policies
resource "aws_s3_bucket_policy" "this" {
  count  = var.enforce_ssl || var.bucket_policy != "" ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = data.aws_iam_policy_document.combined[0].json
}

data "aws_iam_policy_document" "combined" {
  count = var.enforce_ssl || var.bucket_policy != "" ? 1 : 0

  source_policy_documents = compact([
    var.enforce_ssl ? data.aws_iam_policy_document.enforce_ssl[0].json : "",
    var.bucket_policy != "" ? var.bucket_policy : ""
  ])
}

data "aws_iam_policy_document" "enforce_ssl" {
  count = var.enforce_ssl ? 1 : 0

  statement {
    sid     = "EnforceSSL"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "expiration" {
        for_each = rule.value.expiration_days != null ? [1] : []
        content {
          days = rule.value.expiration_days
        }
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration_days != null ? [1] : []
        content {
          noncurrent_days = rule.value.noncurrent_version_expiration_days
        }
      }
    }
  }
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "this" {
  count  = var.enable_notifications ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "lambda_function" {
    for_each = var.lambda_notifications
    content {
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  dynamic "topic" {
    for_each = var.sns_notifications
    content {
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = topic.value.filter_prefix
      filter_suffix = topic.value.filter_suffix
    }
  }
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }

  dynamic "routing_rule" {
    for_each = var.routing_rules
    content {
      condition {
        key_prefix_equals = routing_rule.value.condition.key_prefix_equals
      }
      redirect {
        replace_key_prefix_with = routing_rule.value.redirect.replace_key_prefix_with
      }
    }
  }
}

# S3 Bucket CORS Configuration
resource "aws_s3_bucket_cors_configuration" "this" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

# S3 Bucket Logging
# PSA Compliance: Req 3.66-05 (Logging obligatory)
resource "aws_s3_bucket_logging" "this" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.this.id

  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix
}

# S3 Object Lock Configuration
resource "aws_s3_bucket_object_lock_configuration" "this" {
  count  = var.object_lock_enabled && var.object_lock_configuration != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode  = var.object_lock_configuration.mode
      days  = var.object_lock_configuration.days
      years = var.object_lock_configuration.years
    }
  }
}

# S3 Replication Configuration
resource "aws_s3_bucket_replication_configuration" "this" {
  count  = var.replication_configuration != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  role   = var.replication_configuration.role

  dynamic "rule" {
    for_each = var.replication_configuration.rules
    content {
      id       = rule.value.id
      status   = rule.value.status
      priority = rule.value.priority

      destination {
        bucket        = rule.value.destination.bucket
        storage_class = rule.value.destination.storage_class
      }

      dynamic "filter" {
        for_each = rule.value.filter != null ? [rule.value.filter] : []
        content {
          prefix = lookup(filter.value, "prefix", null)
        }
      }
    }
  }
}

# --- ADVANCED SUPERMARKET RESOURCES ---

# S3 Intelligent-Tiering
resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  for_each = var.intelligent_tiering_configurations

  bucket = aws_s3_bucket.this.id
  name   = each.key
  status = each.value.status

  dynamic "filter" {
    for_each = each.value.filter != null ? [each.value.filter] : []
    content {
      prefix = filter.value.prefix
      tags   = filter.value.tags
    }
  }

  dynamic "tiering" {
    for_each = each.value.tiering
    content {
      access_tier = tiering.value.access_tier
      days        = tiering.value.days
    }
  }
}

# S3 Inventory
resource "aws_s3_bucket_inventory" "this" {
  for_each = var.inventory_configurations

  bucket = aws_s3_bucket.this.id
  name   = each.key

  included_object_versions = each.value.included_object_versions
  optional_fields          = each.value.optional_fields

  schedule {
    frequency = each.value.frequency
  }

  destination {
    bucket {
      format     = each.value.destination_format
      bucket_arn = each.value.destination_bucket_arn
      prefix     = each.value.destination_prefix
    }
  }

  dynamic "filter" {
    for_each = each.value.filter_prefix != null ? [1] : []
    content {
      prefix = each.value.filter_prefix
    }
  }
}

# S3 Analytics
resource "aws_s3_bucket_analytics_configuration" "this" {
  for_each = var.analytics_configurations

  bucket = aws_s3_bucket.this.id
  name   = each.key

  dynamic "filter" {
    for_each = each.value.filter_prefix != null || each.value.filter_tags != null ? [1] : []
    content {
      prefix = each.value.filter_prefix
      tags   = each.value.filter_tags
    }
  }

  storage_class_analysis {
    data_export {
      destination {
        s3_bucket_destination {
          bucket_arn = each.value.storage_class_analysis_data_export_destination_bucket_arn
          prefix     = each.value.storage_class_analysis_data_export_destination_prefix
        }
      }
    }
  }
}
