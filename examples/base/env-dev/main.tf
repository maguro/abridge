module "dev_environment" {
  source = "../env-template"

  deletion_protection = var.deletion_protection

  env     = "dev"
  project = var.project
  region  = var.region

  node_pools_overrides = {
    DEFAULT_OVERRIDES = {
      node_count   = 4
      disk_size_gb = 44
    }
    "pool-01" = {
      # node_count   = 3
      # disk_size_gb = 33
    }
  }
}

module "access" {
  source  = "../../../modules/bastion/access"
  env     = "dev"
  project = var.project
  cluster = "train"
  email   = "alan.cabrera@gmail.com"

  depends_on = [module.dev_environment]
}

resource "google_project_iam_member" "user_email-gke" {
  project = var.project
  role    = "roles/container.viewer"
  member  = "user:alan.cabrera@gmail.com"
}
