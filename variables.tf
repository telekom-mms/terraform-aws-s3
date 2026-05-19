// variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, dev, test)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names (if not provided, will use project-environment pattern)"
  type        = string
  default     = ""
}


variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Name of the S3 bucket (if empty, will use project-environment pattern)"
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Whether to enable versioning"
  type        = bool
  default     = true # Best practice: always enable versioning
}

variable "kms_key_id" {
  description = "The AWS KMS master key ID used for the SSE-KMS encryption"
  type        = string
  default     = ""
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "Object ownership settings (BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced)"
  type        = string
  default     = "BucketOwnerEnforced" # Best practice: disable ACLs
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id                                 = string
    status                             = string
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  default = []
}

variable "enable_notifications" {
  description = "Whether to enable S3 bucket notifications"
  type        = bool
  default     = false
}

variable "lambda_notifications" {
  description = "Map of Lambda notifications"
  type = map(object({
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = optional(string)
    filter_suffix       = optional(string)
  }))
  default = {}
}

variable "sns_notifications" {
  description = "Map of SNS notifications"
  type = map(object({
    topic_arn     = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = {}
}

variable "bucket_policy" {
  description = "Custom JSON-formatted bucket policy"
  type        = string
  default     = ""
}

variable "enforce_ssl" {
  description = "Whether to enforce SSL (HTTPS only) via bucket policy"
  type        = bool
  default     = true # Security first: mandatory SSL
}

variable "enable_website" {
  description = "Whether to enable S3 website configuration"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "Index document for website configuration"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for website configuration"
  type        = string
  default     = "error.html"
}

variable "routing_rules" {
  description = "Routing rules for website configuration"
  type        = any
  default     = []
}

variable "cors_rules" {
  description = "List of CORS rules"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "enable_logging" {
  description = "Whether to enable S3 bucket logging"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Target bucket for logging"
  type        = string
  default     = ""
}

variable "logging_target_prefix" {
  description = "Target prefix for logging"
  type        = string
  default     = "logs/"
}

variable "object_lock_enabled" {
  description = "Whether to enable S3 object lock"
  type        = bool
  default     = false
}

variable "object_lock_configuration" {
  description = "Object lock configuration"
  type = object({
    mode  = string
    days  = optional(number)
    years = optional(number)
  })
  default = null
}

variable "replication_configuration" {
  description = "Replication configuration"
  type = object({
    role = string
    rules = list(object({
      id       = string
      status   = string
      priority = optional(number)
      destination = object({
        bucket        = string
        storage_class = optional(string)
      })
      filter = optional(any)
    }))
  })
  default = null
}

# --- ADVANCED SUPERMARKET FEATURES ---

variable "intelligent_tiering_configurations" {
  description = "Map of S3 Intelligent-Tiering configurations"
  type = map(object({
    status = optional(string, "Enabled")
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    tiering = list(object({
      access_tier = string
      days        = number
    }))
  }))
  default = {}
}

variable "inventory_configurations" {
  description = "Map of S3 Inventory configurations"
  type = map(object({
    destination_bucket_arn   = string
    destination_prefix       = optional(string)
    destination_format       = string
    frequency                = string
    included_object_versions = string
    optional_fields          = optional(list(string))
    filter_prefix            = optional(string)
  }))
  default = {}
}

variable "analytics_configurations" {
  description = "Map of S3 Analytics configurations"
  type = map(object({
    filter_prefix                                             = optional(string)
    filter_tags                                               = optional(map(string))
    storage_class_analysis_data_export_destination_bucket_arn = string
    storage_class_analysis_data_export_destination_prefix     = optional(string)
  }))
  default = {}
}
