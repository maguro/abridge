# Demo Authentication and Authorization

The `gcloud` command has two forms of logins that affect the use of the
`gcloud` and `terraform` commands. This doc explains the differences and how
they are relevant in the two actors used in the demo.

## Authentication for `gcloud` and `terraform`

The `gcloud` and `terraform` commands require that two different logins occur
when using `gcloud auth`.

### Authenticating to `gcloud`

To interact with GCP via `gcloud`, use

```shell
$ gcloud auth login
```

This obtains credentials and stores them in `~/.config/gcloud/`. Now, when
running `gcloud` commands from the terminal, it will find the credentials
automatically.

### Authenticating to `terraform` Via GCP Code SDK

The `terraform` uses the GCP Code SDK. Use

```shell
$ gcloud auth application-default login
```

This obtains credentials and stores them in the known location
`~/.config/gcloud/application_default_credentials.json`. Now, when running
`terraform` commands from the terminal, it will find the credentials
automatically.

## Owner and Operator Actors

Two different actors participate in the demo.

- **Project Owner** - performs the following tasks
    - create the hosting GCP project
    - create two GCS buckets to store the Terraform state files
    - use `terraform` to create the demo clusters and the VPC that hosts them
- **Operator Account** - a "vanilla" GC account
    - use the bastion to create an SSH tunnel to clusters
    - obtain privileges, via the demo, to access the clusters using
      `kubectl`

| actor         | demo setup                                                                                                                                                                             | bastion                                                                                                         |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| project owner | <pre>gcloud auth application-default login<br>gcloud auth login</pre> The former is for `terraform` and the latter is used to check the state of the bastion via the `gcloud` command. | n/a                                                                                                             |
| operator      | n/a                                                                                                                                                                                    | <pre>gcloud auth login</pre> Used to obtain the cluster's Kubernetes credentials and to shell into the bastion. |
