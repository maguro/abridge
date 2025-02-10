module "dev_environment" {
  source = "../env-template"

  deletion_protection = var.deletion_protection

  env     = "dev"
  project = var.project
  region  = var.region

  node_pools_overrides = {
    DEFAULT_OVERRIDES = {
      node_count   = 1
      disk_size_gb = 44
      machine_type    = "e2-micro"
    }
    "pool-01" = {
      node_count   = 1
      # disk_size_gb = 33
    }
  }
}

