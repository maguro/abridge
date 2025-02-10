# GKE Cluster Module
_A demo of an opinionated Terraform GKE cluster module_

---

This module is a demonstration of an opinionated Terraform GKE cluster module.

It is a demo in that not all the knobs and levers of a GKE cluster have been
exposed.  To ease comprehension of the internal structure of this Terraform
module, a minimum of properties such as node pool cardinality, machine type,
etc., have beem exposed.  Admittedly, important features such as autoscaling
have been left out, but it should be a simple matter to add the elided cluster
and node pool properties.

It is opinionated in that it imposes a [nomenclature](https://github.com/maguro/abridge/blob/master/docs/nomenclature.md)
and an architectural topology which always based on a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
as explained below.

## Cluster Types
The module can create two different cluster types

- a general cluster with node pools
- an [Autopilot](https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview) 
  cluster where Google manages your cluster configuration, including your nodes,
  scaling, security, and other preconfigured settings

A cluster with zero node pools becomes an Autopilot cluster.

> [!INFO]
> Admittedly, an explicit flag may be better.  I didn't have time to clean that 
> up; though the cluster types will properly convert to one another when node 
> pools are added or completely deleted. 

## Getting Started

The following things need to be in place to run the examples
See [troubleshooting guide](https://github.com/maguro/abridge/blob/master/examples/README.md)
```text
┌─────────────────────────────────────────────┐
│ env                                         │
│                                             │
│  ┌─────────────────┐   ┌─────────────────┐  │
│  │┌───────┐        │   │┌───────┐        │  │
│  ││bastion│        │   ││bastion│        │  │
│  │└───────┘        │   │└───────┘        │  │
│  │                 │   │                 │  │
│  │┌────┐     ┌────┐│   │┌────┐     ┌────┐│  │
│  ││pool│ ... │pool││   ││pool│ ... │pool││  │
│  │├────┴─────┴────┤│   │├────┴─────┴────┤│  │
│  ││    cluster    ││...││    cluster    ││  │
│  │├───────────────┤│   │├───────────────┤│  │
│  ││    subnet     ││   ││    subnet     ││  │
│  │├───────────────┴┴───┴┴───────────────┤│  │
│  ││                 vpc                 ││  │
│  │└────────────────┬───┬────────────────┘│  │
│  └─────────────────┘   └─────────────────┘  │
│                                             │
└─────────────────────────────────────────────┘
```


## Service Account

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
deployments.  Ensuring the principle of least privilege could be accomplished
in a number of ways.  This module uses the "fixed boilerplate set of roles"
paradigm.

- **custom `variable` entries per role**
    - **pros**: tight custom roles per GKE SA
    - **cons**: bewildering set of `variable` entries making it difficult to 
      grok what roles have or have not been assigned to the specific GKE SA
- **a fixed boilerplate set of roles**
    - **pros**: tighter set roles than the default SA's `Editor` role
    - **cons**: some GKE SAs may have more permissions than needed
- **a fixed set of GKE SAs with fixed roles** - after careful analysis it may be found 
  that a handful of GKE SAs would suffice
    - **pros**: tighter set roles than the default SA's `Editor` role, 
    - **cons**: some GKE SAs may be a close but not perfect fit, and so they 
      would have more permissions than needed


