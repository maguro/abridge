resource "google_service_account" "gke_service_account" {

  for_each = local.node_service_accounts

  project      = var.project
  account_id   = each.value
  display_name = "ABridge ${var.env} environment GKE SA for ${var.cluster} node pool ${each.key}"
  description  = "Terraform managed GKE service account for the ${var.cluster} cluster node pool ${each.key} in the ${var.env} environment"
}

resource "google_project_iam_member" "gke_service_account-default_service_account" {
  for_each = local.node_service_accounts

  project = var.project
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_service_account[each.key].email}"
}

resource "google_project_iam_member" "gke_service_account-log_writer" {
  for_each = local.node_service_accounts

  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_service_account[each.key].email}"
}

resource "google_project_iam_member" "gke_service_account-metric_writer" {
  for_each = local.node_service_accounts

  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_service_account[each.key].email}"
}

resource "google_project_iam_member" "gke_service_account-resourceMetadata-writer" {
  for_each = local.node_service_accounts

  project = var.project
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.gke_service_account[each.key].email}"
}

resource "google_project_iam_member" "gke_service_account-gcr" {
  for_each = local.node_service_accounts

  project = var.project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_service_account[each.key].email}"
}

resource "google_project_iam_member" "gke_service_account-artifact-registry" {
  for_each = local.node_service_accounts

  project = var.project
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_service_account[each.key].email}"
}
