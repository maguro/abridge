# Demo

The demo below creates the `dev` environment which has two clusters
- `a5e-dev-fe-autopilot-tf` - an Autopilot cluster
- `a5e-dev-train-cluster-tf` - a cluster with three pools

Each cluster has its own bastion.

The three pools in `a5e-dev-train-cluster-tf` have been created using overrides
for the `dev` environment; overrides can be used to lower node count and
smaller machine type to appropriate values for `dev`.

```text
┌─────────────────────────────────────────────────────────────────┐
│ dev                                                             │
│                                                                 │
│ ┌───────────────────────────┐   ┌────────────────────────────┐  │
│ │┌─────────────────────┐    │   │┌────────────────────────┐  │  │
│ ││a5e-dev-fe-bastion-tf│    │   ││a5e-dev-train-bastion-tf│  │  │
│ │└─────────────────────┘    │   │└────────────────────────┘  │  │
│ │                           │   │                            │  │
│ │                           │   │┌────────┬────────┬────────┐│  │
│ │                           │   ││pool-01 │pool-02 │pool-03 ││  │
│ │┌─────────────────────────┐│   │├────────┴────────┴────────┤│  │
│ ││ a5e-dev-fe-autopilot-tf ││...││ a5e-dev-train-cluster-tf ││  │
│ │├─────────────────────────┤│   │├──────────────────────────┤│  │
│ ││    a5e-dev-ml-fe-tf     ││   ││   a5e-dev-train-fe-tf    ││  │
│ │├─────────────────────────┴┴───┴┴──────────────────────────┤│  │
│ ││                      a5e-dev-ml-tf                       ││  │
│ │└──────────────────────────┬───┬───────────────────────────┘│  │
│ └───────────────────────────┘   └────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

# Demo Steps

The has four parts. 

1. Set up the prerequisites 
2. Use the Owner Account to create the clusters using `terraform`
3. Use the Operator Account to start the SSH tunnel and send Kubernetes through it
4. Use the Owner Account to teardown the clusters

> [!NOTE]
> The Owner Account has the `Owner` role for the hosting project.  The Operator
> Account should not have any roles other than what's been assigned via 
> Terraform file `examples/demo/env-dev/access.tf`.

## Required Software

- [ ] have `gcloud` installed
- [ ] have `terraform` installed
- [ ] have `kubectl` installed

## 1.0 Demo Setup

The following need to be in place to execute the demo.

- [ ] a GCP project to host the environments' clusters, set the environmental 
      variable `DEMO_PROJECT` to this GCP project
- [ ] access to an GC account that has the `Owner` role for the project (Owner Account)
- [ ] a Google account that has zero privileges, inherited or explicit, for the 
      project (Operator Account)
- [ ] create two GCS buckets for the `dev` and `stg` Terraform states and update
      the `examples/demo/env-dev/000_FILL_ME_IN.tf` and `examples/demo/env-stg/000_FILL_ME_IN.tf`
      files with those bucket name respectively.
- [ ] the email of the GCP project hosting the demo and the Operator Account 
      need to be entered in `examples/demo/env-dev/000_FILL_ME_IN.tf` and 
      `examples/demo/env-stg/000_FILL_ME_IN.tf` before applying Terraform. 

> [!NOTE]
> The Operator Account SHOULD NOT have any privileges in the GCP project that's
> hosting the clusters.  This is to simulate giving ordinary accounts access to
> the bastion; e.g. testing with an account that has the `Owner` role won't 
> prove that the access has been properly configured.

## 2.0 Create the `dev` Environment
Login to the owner of the GCP project
```shell
$ gcloud auth application-default login
$ gcloud auth login
$ cd examples/demo/env-dev
$ terraform init
$ terraform apply
```

## 3.0 SSH Tunnelling Into the `dev` Environment
You will need two terminal windows, one for the tunnel and the other to run the
`kubectl` command.  In this demo, we will use GC account other than the `Owner`
of the hosting GCP project, i.e. a Operator Account that has been given the proper
access in `examples/demo/env-dev/access.tf`.

### 3.1 Log into the Operator Account
Login into the Operator Account and retrieve the Operator Account Kubernetes
credentials.
```shell
$ gcloud auth login
$ gcloud container clusters get-credentials a5e-dev-train-cluster-tf \
    --location=us-central1 \
    --project=$DEMO_PROJECT
```
The `gcloud container clusters get-credentials` command retrieves the credentials
for the `a5e-dev-train-cluster-tf`

### 3.2 Start an SSH Tunnel to the Cluster
In one terminal, start the SSH tunnel using the `gcloud` command.
```shell
$ gcloud compute ssh a5e-dev-train-bastion-tf \
  --tunnel-through-iap \
  --project $DEMO_PROJECT \
  --zone us-central1-c \
  -- -L8888:127.0.0.1:8888
```
A tunnel to the cluster `a5e-dev-train-bastion-tf` has been opened up at
port `8888`
> [!NOTE]
> Any unused port can be used.  There's nothing special about `8888`.  As a 
> matter of fact, multiple SSH tunnels to different clusters can be opened.
 
### 3.3 Use the SSH Tunnel
In a different terminal, log into the cluster and execute a `kubectl get ns`
command to list the namespaces in the cluster.

```shell
$ HTTPS_PROXY=localhost:8888 kubectl get ns
```
You should get back a list of Kubernetes namespaces on that cluster.

## 4.0 Teardown the Cluster
You MUST apply the `deletion_protection` to `false` before attempting to destroy
the cluster.

```shell
$ cd examples/demo/env-dev 
$ terraform apply -var="deletion_protection=false"
$ terraform destroy
```