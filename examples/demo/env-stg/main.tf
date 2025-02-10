module "stg_environment" {
  source = "../env-template"

  deletion_protection = var.deletion_protection

  env     = "stg"
  project = var.project
  region  = var.region

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
}

module "access" {
  source  = "../../../modules/bastion/access"
  env     = "stg"
  project = var.project
  cluster = "train"
  email   = "alan.cabrera@gmail.com"

  depends_on = [module.stg_environment]
}

resource "google_project_iam_member" "user_email-gke" {
  project = var.project
  role    = "roles/container.viewer"
  member  = "user:alan.cabrera@gmail.com"
}
