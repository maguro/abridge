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

## GKE Cluster Module

The module can be found in `modules/gke`.  Read the [`README.md`](https://github.com/maguro/abridge/tree/master/modules/gke/README.md)
for more information.

## Demo

The demo can be found in `examples/base`.  Read the [`DEMO.md`](https://github.com/maguro/abridge/tree/master/examples/DEMO.md)
for more information on running this demo.