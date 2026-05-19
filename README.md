<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]

<br />

<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/telekom-mms/terraform-aws-s3">
    <img src="logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">AWS S3 Module</h3>

  <p align="center">
    PSA-compliant AWS S3 module with intelligent tiering, inventory, and mandatory encryption.
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-s3"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-s3">View Demo</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-s3/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-s3/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

## Documentation

Full auto-generated documentation of inputs, outputs, and resources: [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md)

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
        <li><a href="#opentofu-compatibility">OpenTofu Compatibility</a></li>
        <li><a href="#psa-compliance">PSA Compliance</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#environment-files">Environment Files</a></li>
    <li><a href="#examples">Examples</a></li>
    <li><a href="#security-features">Security Features</a></li>
    <li><a href="#outputs">Outputs</a></li>
    <li><a href="#psa-compliance-features">PSA Compliance Features</a></li>
    <li><a href="#integration">Integration</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This Terraform module creates PSA-compliant AWS S3 buckets with mandatory encryption, versioning, and public access blocks. It goes beyond basic storage by including advanced features like Intelligent-Tiering, Inventory configurations, and Object Lock support out of the box.

### Features

- **Secure by Default**: Mandatory SSE-KMS/AES256, versioning, and Block Public Access.
- **Intelligent-Tiering**: Built-in configurations for cost optimization.
- **Inventory**: Automated inventory reporting for auditing and analysis.
- **Object Lock**: Write-Once-Read-Many (WORM) support for compliance.
- **Lifecycle Management**: granular rules for transitioning and expiring objects.
- **Replication**: Cross-region replication support for disaster recovery.
- **Access Control**: Enforced `BucketOwnerEnforced` ownership (ACLs disabled).

### OpenTofu Compatibility

This module is designed to work with both Terraform and OpenTofu. The module uses standard HCL syntax that is compatible with both tools, ensuring seamless integration regardless of which infrastructure-as-code tool you choose.

### PSA Compliance

PSA compliance is an internal best practice that is automatically enforced by this module. All resources created by this module automatically adhere to PSA compliance standards (e.g., Req 3.50-01 for encryption, Req 3.66-05 for logging) without requiring any additional configuration.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

- Terraform v1.3 or higher
- AWS CLI configured with appropriate permissions

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/telekom-mms/terraform-aws-s3.git
   ```
2. Navigate to the module directory
   ```sh
   cd terraform-aws-s3
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->
## Usage

This module can be used with or without environment files. Below are examples of both approaches.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ENVIRONMENT FILES -->
## Environment Files

The module supports environment-specific configuration through external environment files.

1. **Template File**: A template file `env-template.tfvars` is provided in the `env/` directory.
2. **Creating Environment Files**: Copy `env-template.tfvars` to `env/env-<environment>.tfvars`.
3. **Using Environment Files**: Specify the environment file via the `-var-file` parameter.

```hcl
module "s3" {
  source = "./terraform-aws-s3"

  # Required variables
  project_name = "myapp"
  environment  = "prod"
  
  # Bucket Configuration
  bucket_name = "my-secure-data-lake"
  
  # Advanced Features
  intelligent_tiering_configurations = {
    general = {
      status = "Enabled"
      tiering = [
        { access_tier = "ARCHIVE_ACCESS", days = 90 },
        { access_tier = "DEEP_ARCHIVE_ACCESS", days = 180 }
      ]
    }
  }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- EXAMPLES -->
## Examples

### Basic Usage

```hcl
module "s3" {
  source = "./terraform-aws-s3"

  project_name = "demo"
  environment  = "dev"
  
  bucket_name = "demo-assets"
  versioning_enabled = true
}
```

### Advanced Usage with Replication and Inventory

```hcl
module "s3" {
  source = "./terraform-aws-s3"

  project_name = "finance"
  environment  = "prod"
  bucket_name  = "finance-records"
  
  # Security
  kms_key_id          = "arn:aws:kms:region:account:key/..."
  object_lock_enabled = true
  object_lock_configuration = {
    mode  = "COMPLIANCE"
    years = 7
  }
  
  # Inventory
  inventory_configurations = {
    daily_report = {
      destination_bucket_arn = "arn:aws:s3:::audit-logs"
      destination_format     = "Parquet"
      frequency              = "Daily"
      included_object_versions = "All"
      optional_fields        = ["Size", "LastModifiedDate", "StorageClass"]
    }
  }
  
  tags = {
    Classification = "Confidential"
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | ID of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |
| `bucket_domain_name` | FQDN of the bucket |
| `bucket_website_endpoint` | Website endpoint (if enabled) |
| `encryption_configuration` | Map of encryption settings |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SECURITY FEATURES -->
## Security Features

- **Public Access Block**: Completely blocks all public access (ACLs and Policies) by default.
- **Enforced Encryption**: Server-Side Encryption (SSE) is mandatory; KMS support is built-in.
- **SSL Enforcement**: Bucket policy automatically denies non-SSL (HTTP) transport.
- **Disable ACLs**: `BucketOwnerEnforced` is the default ownership setting to modernize access control.
- **Object Lock**: Supports WORM compliance models.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- PSA COMPLIANCE FEATURES -->
## PSA Compliance Features

This module implements the following PSA compliance features (referencing `01-Strukturierte_PSA_Anforderungen_Allgemein.pdf`):

### Security Controls

- **Req 3.50-01 (Encryption)**: KMS/AES256 mandatory for data at rest.
- **Req 3.66-05 (Logging)**: Server access logging support with dedicated target bucket.
- **Req 3.50-04 (TLS)**: Deny-policy for non-SSL connections.
- **Req 3.01-02 (Integrity)**: Versioning enabled by default to protect against accidental deletion/overwrites.

### Operational Excellence

- **Cost Management**: Intelligent-Tiering and Lifecycle rules to manage storage classes.
- **Auditability**: Inventory configurations for complete object visibility.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- INTEGRATION -->
## Integration

### Related Modules

- [terraform-aws-kms](../terraform-aws-kms) - Encryption keys
- [terraform-aws-iam-roles](../terraform-aws-iam-roles) - Cross-account access
- [terraform-aws-cloudfront](../terraform-aws-cloudfront) - Content delivery

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- TROUBLESHOOTING -->
## Troubleshooting

### Access Denied

- Check if `block_public_acls` or `restrict_public_buckets` is preventing access.
- Verify KMS key policy allows the calling principal to Decrypt/GenerateDataKey.
- Ensure the bucket policy explicitly allows the principal.

### Bucket Deletion Fails

- S3 buckets cannot be deleted if they contain objects. Set `force_destroy = true` (use with caution!) or empty the bucket first.
- Check if Object Lock is enabled (cannot delete locked objects until retention expires).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the Mozilla Public License Version 2.0. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Project Link: [https://github.com/telekom-mms/terraform-aws-s3](https://github.com/telekom-mms/terraform-aws-s3)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/telekom-mms/terraform-aws-s3.svg?style=for-the-badge
[contributors-url]: https://github.com/telekom-mms/terraform-aws-s3/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/telekom-mms/terraform-aws-s3.svg?style=for-the-badge
[forks-url]: https://github.com/telekom-mms/terraform-aws-s3/network/members
[stars-shield]: https://img.shields.io/github/stars/telekom-mms/terraform-aws-s3.svg?style=for-the-badge
[stars-url]: https://github.com/telekom-mms/terraform-aws-s3/stargazers
[issues-shield]: https://img.shields.io/github/issues/telekom-mms/terraform-aws-s3.svg?style=for-the-badge
[issues-url]: https://github.com/telekom-mms/terraform-aws-s3/issues
[license-shield]: https://img.shields.io/github/license/telekom-mms/terraform-aws-s3.svg?style=for-the-badge
[license-url]: https://github.com/telekom-mms/terraform-aws-s3/blob/master/LICENSE.txt

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

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
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.enforce_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
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
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g., prod, dev, test) | `string` | n/a | yes |
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
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Replication configuration | <pre>object({<br/>    role = string<br/>    rules = list(object({<br/>      id       = string<br/>      status   = string<br/>      priority = optional(number)<br/>      destination = object({<br/>        bucket        = string<br/>        storage_class = optional(string)<br/>      })<br/>      filter = optional(object({<br/>        prefix = optional(string)<br/>        tag = optional(object({<br/>          key   = string<br/>          value = string<br/>        }))<br/>        and = optional(object({<br/>          prefix = optional(string)<br/>          tags   = optional(map(string))<br/>        }))<br/>      }))<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket | `bool` | `true` | no |
| <a name="input_routing_rules"></a> [routing\_rules](#input\_routing\_rules) | Routing rules for website configuration | <pre>list(object({<br/>    condition = optional(object({<br/>      http_error_code_returned_equals = optional(string)<br/>      key_prefix_equals               = optional(string)<br/>    }))<br/>    redirect = object({<br/>      host_name               = optional(string)<br/>      http_redirect_code      = optional(string)<br/>      protocol                = optional(string)<br/>      replace_key_prefix_with = optional(string)<br/>      replace_key_with        = optional(string)<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_sns_notifications"></a> [sns\_notifications](#input\_sns\_notifications) | Map of SNS notifications | <pre>map(object({<br/>    topic_arn     = string<br/>    events        = list(string)<br/>    filter_prefix = optional(string)<br/>    filter_suffix = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Whether to enable versioning | `bool` | `true` | no |

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