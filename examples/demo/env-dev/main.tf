module "dev_environment" {
  source = "../env-template"

  deletion_protection = var.deletion_protection

  env     = "dev"
  project = var.project
  region  = var.region

  node_pools_overrides = {
    // this overrides the defaults
    DEFAULT_OVERRIDES = {
      disk_size_gb = 10
      machine_type = "e2-micro"
    }

    // this overrides the specific pool settings
    "pool-01" = {
      node_count = 1
    }
    "pool-02" = {
      node_count = 1
    }
    "pool-03" = {
      node_count = 1
    }
  }
}

