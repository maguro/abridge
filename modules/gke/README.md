# GKE Cluster Module

_A demo of an opinionated Terraform GKE cluster module_

---

This module is a demonstration of an opinionated Terraform GKE cluster module.

It is a demo in that not all the knobs and levers of a GKE cluster have been
exposed. To ease comprehension of the internal structure of this Terraform
module, a minimum of properties such as node pool cardinality, machine type,
etc., have beem exposed. Admittedly, important features such as autoscaling
have been left out, but it should be a simple matter to add the elided cluster
and node pool properties.

It is opinionated in that it imposes a [nomenclature](https://github.com/maguro/abridge/blob/master/docs/nomenclature.md)
and an architectural topology which always based on a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
as explained below.

## Usage

There is a complete examples included in the [examples/demo](https://github.com/maguro/abridge/tree/master/examples/demo)
folder, read [`DEMO.md`](https://github.com/maguro/abridge/tree/master/examples/DEMO.md),
but simple usage is as follows:

```hcl
module "training_cluster" {
  source              = "../../../modules/gke"
  deletion_protection = var.deletion_protection
  cluster             = local.section_training
  project             = var.project
  env                 = var.env
  vpc                 = local.team_ml
  vpc_network_id = module.vpc_ml.vpc_network_id

  // CIDR ranges are defined here
  cidr_prefix_lengths = {
    nodes    = 16
    pods     = 16
    services = 24
  }

  node_pools = [
    {
      name       = "pool-01"
      node_count = 10
    },
    {
      name              = "pool-02"
      node_count        = 10
      disk_type         = "pd-balanced"
      service_account   = google_service_account.special_service_account.email
      accelerator_type  = "nvidia-tesla-k80"
      accelerator_count = 1
    },
  ]

  // Allow environments to override node pool settings
  node_pools_overrides = var.node_pools_overrides
}

```

## Inputs

### Cluster Configuration

| Name                | Description                                                                                                                                                                                | Type                                                                                                                                                                                                                                                                            | Default           | Required |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|:--------:|
| cidr_prefix_lengths | The CIDR prefix lengths that are used to reserve CIDR ranges                                                                                                                               | <pre>object({<br>  nodes = number,<br>  pods = number,<br>  services = number<br>})</pre>                                                                                                                                                                                       | n/a               |   yes    |
| cluster             | The name of the cluster                                                                                                                                                                    | `string`                                                                                                                                                                                                                                                                        | n/a               |   yes    |
| deletion_protection | Used to override deletion protection                                                                                                                                                       | `bool`                                                                                                                                                                                                                                                                          | `true`            |    no    |
| env                 | The environment the cluster belongs to                                                                                                                                                     | `string`                                                                                                                                                                                                                                                                        | n/a               |   yes    |
| node_pools          | The node pools to create within the cluster.  If no pools are defined, the cluster is an [Autopilot](https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview) cluster. | <pre>list(<br>  object({<br>    name = string,<br>    node_locations = string<br>    node_count = number<br>    machine_type = string<br>    service_account = string<br>    local_ssd_count = number<br>    disk_size_gb = number<br>    disk_type = string<br>  })<br>)</pre> | Autopilot Cluster |    no    |
| project             | The name of the GCP project hosting the cluster                                                                                                                                            | `string`                                                                                                                                                                                                                                                                        | n/a               |   yes    |
| vpc                 | The VPC that the cluster resides in, not the GCP VPC name                                                                                                                                  | `string`                                                                                                                                                                                                                                                                        | n/a               |   yes    |
| vpc_network_id      | The GCP VPC network id                                                                                                                                                                     | `string`                                                                                                                                                                                                                                                                        | n/a               |   yes    |

> [!NOTE]
> Admittedly, an explicit flag to control the cluster type may be better.
> I didn't have time to clean that up; though the cluster types will properly
> convert to one another when node pools are added or completely deleted.

### Node Pool Configuration

| Name                           | Description                                                                                                                                                                                                                                                                                                                                                            | Type     | Default                                                |                                            Required                                            |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|--------------------------------------------------------|:----------------------------------------------------------------------------------------------:|
| disk\_size\_gb                 | Size of the disk attached to each node, specified in GB                                                                                                                                                                                                                                                                                                                | `number` | `100`                                                  |                                               no                                               |
| disk\_type                     | Type of the disk attached to each node (e.g. `pd-standard`, `pd-balanced` or `pd-ssd`).                                                                                                                                                                                                                                                                                | `string` | `pd-standard`                                          |                                               no                                               |
| local\_ssd\_count              | The amount of local SSD disks that will be attached to each cluster node                                                                                                                                                                                                                                                                                               | `number` | `0`                                                    |                                               no                                               |
| name                           | The name of the node pool                                                                                                                                                                                                                                                                                                                                              | `string` | n/a                                                    |                                              yes                                               |
| node\_locations                | A comma delimited list of zones in which the cluster's nodes are located                                                                                                                                                                                                                                                                                               | `string` | `null`                                                 |                                               no                                               |
| node\_count                    | The number of nodes in the pool                                                                                                                                                                                                                                                                                                                                        | `number` | `1`                                                    |                                               no                                               |
| service\_account               | A custom Service Account account to be used by the node VMs created by GKE Autopilot or NAP.  Setting this value overrides the default Service Account; see below.                                                                                                                                                                                                     | `string` | [Default Service Account](#node-pool-service-accounts) |                                               no                                               |
| **`guest_accelerator`**        |                                                                                                                                                                                                                                                                                                                                                                        |          |                                                        |                                                                                                |
| accelerator\_type              | The accelerator type resource to expose to this instance. E.g. `nvidia-tesla-k80`.                                                                                                                                                                                                                                                                                     | `string` | `""`                                                   |                                               no                                               |
| accelerator\_count             | The number of the guest accelerator cards exposed to this instance.                                                                                                                                                                                                                                                                                                    | `number` | `0`                                                    |                                               no                                               |
| gpu\_partition\_size           | Size of partitions to create on the GPU. Valid values are described in the NVIDIA mig [user guide](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#partitioning).                                                                                                                                                                                             | `number` | `null`                                                 |                                               no                                               |
| gpu\_driver\_version           | Mode for how the GPU driver is installed. Accepted values are:<ul><li> `"GPU_DRIVER_VERSION_UNSPECIFIED"`: Default value is to not install any GPU driver. <li>`"INSTALLATION_DISABLED"`: Disable GPU driver auto installation and needs manual installation. <li>`"DEFAULT"`: "Default" GPU driver in COS and Ubuntu.<li>`"LATEST"`: "Latest" GPU driver in COS.</ul> | `string` | `""`                                                   |                                               no                                               |
| gpu\_sharing\_strategy         | The type of GPU sharing strategy to enable on the GPU node. Accepted values are:<ul><li>`"TIME_SHARING"`: Allow multiple containers to have time-shared access to a single GPU device.<li>`"MPS"`: Enable co-operative multi-process CUDA workloads to run concurrently on a single GPU device with MPS</ul>                                                           | `string` | `""`                                                   | no<br> if max\_shared\_clients\_per\_gpu is specified then gpu\_sharing\_strategy is required. |
| max\_shared\_clients\_per\_gpu | The maximum number of containers that can share a GPU.                                                                                                                                                                                                                                                                                                                 | `number` | `2`                                                    | no<br> if gpu\_sharing\_strategy is specified then max\_shared\_clients\_per\_gpu is required. |

## Cluster Architecture

The root is the environment, e.g. `dev`, `stg`, `prd`, where each topology is
the same across all environments but the cardinality of the node pools and
their machine type would be different; e.g. `dev` would have a handful of nodes
and small machine types.

```text
┌─────────────────────────────────────────────────────────────────┐
│ env                                                             │
│                                                                 │
│  ┌─────────────────┐   ┌─────────────────┐    ┌──────────────┐  │
│  │┌───────┐        │   │┌───────┐        │    │ ┌───────┐    │  │
│  ││bastion│        │   ││bastion│        │    │ │bastion│    │  │
│  │└───────┘        │   │└───────┘        │    │ └───────┘    │  │
│  │                 │   │                 │    │              │  │
│  │┌────┐     ┌────┐│   │┌────┐     ┌────┐│    │ ┌────┐       │  │
│  ││pool│ ... │pool││   ││pool│ ... │pool││    │ │pool│ ...   │  │
│  │├────┴─────┴────┤│   │├────┴─────┴────┤│    │ ├────┴───────┤  │
│  ││    cluster    ││...││    cluster    ││    │ │  cluster   │  │
│  │├───────────────┤│   │├───────────────┤│    │ ├────────────┤  │
│  ││    subnet     ││   ││    subnet     ││    │ │   subnet   │  │
│  │├───────────────┴┴───┴┴───────────────┤│    │ ├────────────┴─ │
│  ││                 vpc                 ││ ...│ │    vpc        │
│  │└────────────────┬───┬────────────────┘│    │ └────────────┬─ │
│  └─────────────────┘   └─────────────────┘    └──────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Virtual Private Cloud

[Virtual Private Clouds](https://cloud.google.com/vpc?hl=en) (VPC) form the base
on which clusters live. There can be multiple VPCs within an environment.

### Cluster/Subnets

Every cluster resides in its own subnet. Each cluster can host multiple node
pools, or it can be an [Autopilot](https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview)
cluster if no node pools are defined.

#### Cluster CIDR Ranges

Each cluster has three [internal IP CIDR ranges](https://cloud.google.com/vpc/docs/internal-ranges)
allocated whose prefix length is configurable.

- nodes
- pods
- services

These internal IP CIDR ranges are reserved and allocated to the subnet of the
cluster. The cluster will allocate IPs for its nodes, pods, and services from
these reserve ranges. Using internal ranges will protect clusters from range
overlap and alleviate the DevOps engineer from having to micromanage CIDR ranges.

There are no public IPs used.

#### Cluster Bastion

Since the clusters are on a private network, a bastion is required to perform
tasks such as executing `kubectl` commands as well as other possible ad hoc
admin work via SSH tunnelling.

Each cluster gets its own bastion and access to that bastion is controlled by
an [Identity Aware Proxy](https://cloud.google.com/security/products/iap?hl=en) (IAP).
This allows for the fine-grained access control of the bastions down at the
individual level; the file `examples/base/env-dev/access.tf` gives an example
of how access to two different bastions can be granted.

Access to the bastion is performed using the `gcloud compute ssh` command with
the `--tunnel-through-iap` option. Read [`DEMO.md`](https://github.com/maguro/abridge/tree/master/examples/DEMO.md)
to see an example of how this is done.

## Node Pool Service Accounts

Each GKE node pool is configured with a custom service account (GKE SA) that
has stricter IAM role assignments than the generic default service account used
by GKE.

### GKE SA Roles

The GKE SA of the node pool has the following IAM roles:

- `container.defaultNodeServiceAccount` - the minimum role required for a GKE
  node pool SA.
- `logging.logWriter`
- `monitoring.metricWriter`
- `monitoring.metricReader`
- `stackdriver.resourceMetadata.writer`
- `storage.objectViewer`
- `artifactregistry.reader`

It's possible that many are not needed, e.g. `storage.objectViewer` for many
deployments. Ensuring the principle of least privilege could be accomplished
in a number of ways. This module uses the "fixed boilerplate set of roles"
paradigm.

> [!Note]
> I could have organized the GKE Service Accounts and their roles a number of
> ways. A fixed custom seto of Service Accounts shared across all the clusters
> would have been ideal, but that would have required some analysis as to how
> the clusters are being used. Given this, a Service Account with a boilerplate
> set of roles seems to be the next best thing.
> - **custom `variable` entries per role**
>   - **pros**: tight custom roles per GKE SA
>   - **cons**: bewildering set of `variable` entries making it difficult to
>               grok what roles have or have not been assigned to the specific GKE SA
> - **a fixed boilerplate set of roles**
>   - **pros**: tighter set roles than the default SA's `Editor` role
>   - **cons**: some GKE SAs may have more permissions than needed
> - **a fixed set of GKE SAs with fixed roles** - after careful analysis it may be found
>    that a handful of GKE SAs would suffice
>   - **pros**: tighter set roles than the default SA's `Editor` role,
>   - **cons**: some GKE SAs may be a close but not perfect fit, and so they
>               would have more permissions than needed

## Node Pool Overrides

Environments can override template defaults as well as specific node pool
configurations. This facilitates the economical pruning of environments
such as `dev` and `stg`.

```hcl
node_pools_overrides = {
  // this overrides the defaults
  DEFAULT_OVERRIDES = {
    disk_size_gb = 50
    machine_type = "e2-micro"
  }

  // this overrides the specific pool settings
  "pool-01" = {
    node_count = 2
  }
  "pool-02" = {
    node_count = 2
  }
  "pool-03" = {
    node_count = 2
  }
}
```

Here, the default disk size is lowered from 100G to 50G and the default machine
type is changed from `e2-medium` to `e2-micro`.

### Default Overrides

Template defaults can be overridden by specifying replacement values in the
`DEFAULT_OVERRIDES` map entry within `node_pools_overrides`.

### Pool Overrides

Template node pool values can be overridden by specifying replacement values in the
`<node pool name>` map entry within `node_pools_overrides`.
