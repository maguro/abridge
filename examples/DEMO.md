# Examples


## Getting Started

The following need to be in place to execute the examples within.

- Have `gcloud` installed
- A GCP project to host the environments' clusters
- Access to an GC account that has the `Owner` role for the project (Owner Account)
- A Google account that has zero privileges, inherited or explicit, for the project (Bastion Account)
- The email of the Bastion Account needs to be entered in `examples/base/env-dev/access.tf` to give it access to the bastions

> [!WARNING]
> The Bastion Account SHOULD NOT have any privileges in the GCP project that's
> hosting the clusters.  This is to simulate

Login to the owner of the GCP project
```shell
$ gcloud auth application-default login
```