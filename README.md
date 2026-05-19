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
