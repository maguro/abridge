module "dev_environment" {
  source = "../env-template"

  deletion_protection = var.deletion_protection

  env     = "stg"
  project = var.project
  region  = var.region
}

module "access" {
  source       = "../../../modules/bastion/access"
  env          = "stg"
  project      = var.project
  cluster = "train"
  email        = "alan.cabrera@gmail.com"

  depends_on = [module.dev_environment]
}

resource "google_project_iam_member" "user_email-gke" {
  project = var.project
  role    = "roles/container.viewer"
  member  = "user:alan.cabrera@gmail.com"
}
