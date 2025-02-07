# vpc module

This module generates the required labels for GCP terraform resources.

This module will:

- Create a map of labels based on the input variables

## Usage

Basic usage of this module is as follows:

```hcl
module "labels" {
  source  = "gcp/modules/gcp-labels-tf"
  env     = var.env
  owner   = var.owner
  project = var.project
  service = var.service
}
```

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] >= v0.13
- [Terraform Provider for GCP][terraform-provider-gcp]

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0.0, < 6 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | The short-hand environment name | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | The email of the team that owns this IAC resource without the domain i.e. who should be contacted for changes/issues | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The GCP project id | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | The service name to use in the naming of resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_required_labels"></a> [required\_labels](#output\_required\_labels) | Generated required labels based on the input variables |
<!-- END_TF_DOCS -->