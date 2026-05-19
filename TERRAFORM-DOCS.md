<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.1 |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_analytics_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_analytics_configuration) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_inventory.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g., prod, dev, test) | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_analytics_configurations"></a> [analytics\_configurations](#input\_analytics\_configurations) | Map of S3 Analytics configurations | <pre>map(object({<br/>    filter_prefix                                             = optional(string)<br/>    filter_tags                                               = optional(map(string))<br/>    storage_class_analysis_data_export_destination_bucket_arn = string<br/>    storage_class_analysis_data_export_destination_prefix     = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket (if empty, will use project-environment pattern) | `string` | `""` | no |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | Custom JSON-formatted bucket policy | `string` | `""` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | List of CORS rules | <pre>list(object({<br/>    allowed_headers = list(string)<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = optional(list(string))<br/>    max_age_seconds = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Whether to enable S3 bucket logging | `bool` | `false` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Whether to enable S3 bucket notifications | `bool` | `false` | no |
| <a name="input_enable_website"></a> [enable\_website](#input\_enable\_website) | Whether to enable S3 website configuration | `bool` | `false` | no |
| <a name="input_enforce_ssl"></a> [enforce\_ssl](#input\_enforce\_ssl) | Whether to enforce SSL (HTTPS only) via bucket policy | `bool` | `true` | no |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | Error document for website configuration | `string` | `"error.html"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket | `bool` | `true` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | Index document for website configuration | `string` | `"index.html"` | no |
| <a name="input_intelligent_tiering_configurations"></a> [intelligent\_tiering\_configurations](#input\_intelligent\_tiering\_configurations) | Map of S3 Intelligent-Tiering configurations | <pre>map(object({<br/>    status = optional(string, "Enabled")<br/>    filter = optional(object({<br/>      prefix = optional(string)<br/>      tags   = optional(map(string))<br/>    }))<br/>    tiering = list(object({<br/>      access_tier = string<br/>      days        = number<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_inventory_configurations"></a> [inventory\_configurations](#input\_inventory\_configurations) | Map of S3 Inventory configurations | <pre>map(object({<br/>    destination_bucket_arn   = string<br/>    destination_prefix       = optional(string)<br/>    destination_format       = string<br/>    frequency                = string<br/>    included_object_versions = string<br/>    optional_fields          = optional(list(string))<br/>    filter_prefix            = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The AWS KMS master key ID used for the SSE-KMS encryption | `string` | `""` | no |
| <a name="input_lambda_notifications"></a> [lambda\_notifications](#input\_lambda\_notifications) | Map of Lambda notifications | <pre>map(object({<br/>    lambda_function_arn = string<br/>    events              = list(string)<br/>    filter_prefix       = optional(string)<br/>    filter_suffix       = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of lifecycle rules | <pre>list(object({<br/>    id                                 = string<br/>    status                             = string<br/>    expiration_days                    = optional(number)<br/>    noncurrent_version_expiration_days = optional(number)<br/>    transitions = optional(list(object({<br/>      days          = number<br/>      storage_class = string<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_logging_target_bucket"></a> [logging\_target\_bucket](#input\_logging\_target\_bucket) | Target bucket for logging | `string` | `""` | no |
| <a name="input_logging_target_prefix"></a> [logging\_target\_prefix](#input\_logging\_target\_prefix) | Target prefix for logging | `string` | `"logs/"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names (if not provided, will use project-environment pattern) | `string` | `""` | no |
| <a name="input_object_lock_configuration"></a> [object\_lock\_configuration](#input\_object\_lock\_configuration) | Object lock configuration | <pre>object({<br/>    mode  = string<br/>    days  = optional(number)<br/>    years = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | Whether to enable S3 object lock | `bool` | `false` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership settings (BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced) | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Replication configuration | <pre>object({<br/>    role = string<br/>    rules = list(object({<br/>      id       = string<br/>      status   = string<br/>      priority = optional(number)<br/>      destination = object({<br/>        bucket        = string<br/>        storage_class = optional(string)<br/>      })<br/>      filter = optional(object({<br/>        prefix = optional(string)<br/>        tag = optional(object({<br/>          key   = string<br/>          value = string<br/>        }))<br/>        and = optional(object({<br/>          prefix = optional(string)<br/>          tags   = optional(map(string))<br/>        }))<br/>      }))<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket | `bool` | `true` | no |
| <a name="input_routing_rules"></a> [routing\_rules](#input\_routing\_rules) | Routing rules for website configuration | <pre>list(object({<br/>    condition = optional(object({<br/>      http_error_code_returned_equals = optional(string)<br/>      key_prefix_equals               = optional(string)<br/>    }))<br/>    redirect = object({<br/>      host_name               = optional(string)<br/>      http_redirect_code      = optional(string)<br/>      protocol                = optional(string)<br/>      replace_key_prefix_with = optional(string)<br/>      replace_key_with        = optional(string)<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_sns_notifications"></a> [sns\_notifications](#input\_sns\_notifications) | Map of SNS notifications | <pre>map(object({<br/>    topic_arn     = string<br/>    events        = list(string)<br/>    filter_prefix = optional(string)<br/>    filter_suffix = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Whether to enable versioning | `bool` | `true` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the S3 bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Bucket domain name |
| <a name="output_bucket_hosted_zone_id"></a> [bucket\_hosted\_zone\_id](#output\_bucket\_hosted\_zone\_id) | Hosted zone ID of the S3 bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the S3 bucket |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the S3 bucket |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | Region of the S3 bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | Regional domain name of the S3 bucket |
| <a name="output_bucket_website_domain"></a> [bucket\_website\_domain](#output\_bucket\_website\_domain) | Domain name of the website endpoint |
| <a name="output_bucket_website_endpoint"></a> [bucket\_website\_endpoint](#output\_bucket\_website\_endpoint) | Website endpoint of the S3 bucket |
| <a name="output_encryption_configuration"></a> [encryption\_configuration](#output\_encryption\_configuration) | Encryption configuration of the S3 bucket |
| <a name="output_lambda_notification_arns"></a> [lambda\_notification\_arns](#output\_lambda\_notification\_arns) | Configured Lambda notification target ARNs |
| <a name="output_logging_target_bucket"></a> [logging\_target\_bucket](#output\_logging\_target\_bucket) | Target bucket receiving server access logs |
| <a name="output_notification_arns"></a> [notification\_arns](#output\_notification\_arns) | Configured notification target ARNs |
| <a name="output_object_lock_enabled"></a> [object\_lock\_enabled](#output\_object\_lock\_enabled) | Whether object lock is enabled for the bucket |
| <a name="output_object_lock_status"></a> [object\_lock\_status](#output\_object\_lock\_status) | Object lock status for the bucket |
| <a name="output_public_access_block_configuration"></a> [public\_access\_block\_configuration](#output\_public\_access\_block\_configuration) | Public access block configuration |
| <a name="output_replication_configuration"></a> [replication\_configuration](#output\_replication\_configuration) | Replication configuration applied to the bucket |
| <a name="output_sns_notification_arns"></a> [sns\_notification\_arns](#output\_sns\_notification\_arns) | Configured SNS notification target ARNs |
| <a name="output_versioning_enabled"></a> [versioning\_enabled](#output\_versioning\_enabled) | Whether versioning is enabled |
<!-- END_TF_DOCS -->