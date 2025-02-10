##
## An example of a custom service account that can be used for a node pool
## instead of the templatized service account created by the GKE module.
##
resource "google_service_account" "special_service_account" {

  project      = var.project
  account_id   = "a5e-${var.env}-special-tf"
  display_name = "Special ABridge ${var.env} environment GKE SA"
  description  = "Terraform managed special ABridge ${var.env} environment GKE SA"
}

resource "google_project_iam_member" "special_service_account-default_service_account" {
  project = var.project
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.special_service_account.email}"
}
