# Bastion Access
_Terraform module to provide access to GKE cluster bastion_

---

## Usage
There are multiple examples included in the [examples](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/examples) folder but simple usage is as follows:

```hcl
# google_client_config and kubernetes provider must be explicitly specified like the following.
module "access" {
  source       = "../../../modules/bastion/access"
  env          = "dev"
  project      = "abridge-takehome"
  cluster      = "train"
  email        = "alan.cabrera@gmail.com"

  depends_on = [module.dev_environment]
}
```
## Inputs

| Name    | Description                                        | Type     | Default | Required |
|---------|----------------------------------------------------|----------|-|:--------:|
| env     | Environment being managed                          | `string` | |   yes    |
| project | GCP project hosting cluster                        | `string` | |   yes    |
| cluster | Name of the GKE cluster bastion is associated with | `string` | |   yes    |
| zone    | Zone of bastion                                    | `string` | |   yes    |
| email   | Google email of user being granted bastion access  | `string` | |   yes    |

## Outputs
None

## Requirements
Before this module can be used you must ensure that the bastion already exists.
