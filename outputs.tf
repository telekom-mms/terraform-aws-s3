// outputs.tf

output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_region" {
  description = "Region of the S3 bucket"
  value       = aws_s3_bucket.this.region
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "Hosted zone ID of the S3 bucket"
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "bucket_website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = var.enable_website ? aws_s3_bucket_website_configuration.this[0].website_endpoint : null
}

output "bucket_website_domain" {
  description = "Domain name of the website endpoint"
  value       = var.enable_website ? aws_s3_bucket_website_configuration.this[0].website_domain : null
}

output "versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = var.versioning_enabled
}

output "encryption_configuration" {
  description = "Encryption configuration of the S3 bucket"
  value = {
    sse_algorithm     = var.kms_key_id != "" ? "aws:kms" : "AES256"
    kms_master_key_id = var.kms_key_id
  }
}

output "public_access_block_configuration" {
  description = "Public access block configuration"
  value = {
    block_public_acls       = var.block_public_acls
    block_public_policy     = var.block_public_policy
    ignore_public_acls      = var.ignore_public_acls
    restrict_public_buckets = var.restrict_public_buckets
  }
}
