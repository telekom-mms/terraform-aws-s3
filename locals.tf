// locals.tf

locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : "${var.project_name}-${var.environment}"
  bucket_name = var.bucket_name != "" ? var.bucket_name : "${local.name_prefix}-bucket"

  common_tags = merge(var.tags, {
    "Project"       = var.project_name
    "Environment"   = var.environment
    "ManagedBy"     = "Terraform"
    "PSA-Compliant" = "true"
  })
}
