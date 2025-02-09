resource "google_service_account" "bastion_service_account" {
  project      = var.project
  account_id   = "a5e-${var.env}-${var.cluster_name}-bastion-tf"
  display_name = "${var.env} bastion service account"
  description  = "Terraform managed Service Account for bastion in ${var.env}"
}

resource "google_project_iam_member" "bastion_service_account-monitoring_metric_writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.bastion_service_account.email}"
}
