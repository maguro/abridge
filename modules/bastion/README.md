# Bastion

_Providing ssh tunnel access to a private GKE cluster_

---

## Using the Bastion

Three general steps need to be performed in order to use the bastion to access
its associated private GKE cluster.

1. Login to `gcloud` and obtain your Kubernetes credentials of the private GKE
   cluster.
2. Create the SSH tunnel to the bastion.
3. Point HTTPS_PROXY to the above ssh tunnel.

### Example

| description     | value                      |
|-----------------|----------------------------|
| project         | `abridge-takehome`         |
| GKE cluster     | `a5e-stg-train-tf`         |
| location        | `us-central1`              |
| bastion         | `a5e-stg-train-bastion-tf` |
| bastion zone    | `us-central1-c`            |
| SSH tunnel port | `8888`                     |

Authorize gcloud to access the Cloud Platform with Google user credentials then
obtain the GKE credentials of for that Google user.

```shell
$ gcloud auth login
$ gcloud container clusters get-credentials a5e-stg-train-tf \
    --location=us-central1 \
    --project=abridge-takehome
```

In a separate terminal, open an ssh tunnel to the bastion associated with the
desired private GKE cluster. Here port `8888` is used; any unused port should
work.

```shell
$ gcloud compute ssh a5e-stg-train-bastion-tf --tunnel-through-iap \
  --project abridge-takehome \
  --zone us-central1-c -- -L8888:127.0.0.1:8888
```

Point `HTTPS_PROXY` to the above ssh tunnel.

```shell
$ export HTTPS_PROXY=localhost:8888
$ kubectl get ns
```