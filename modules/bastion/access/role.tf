resource "google_project_iam_member" "user_email-ssh_bastion" {
  project = var.project
  role    = "projects/${var.project}/roles/a5e_${var.env}_${var.cluster}_ssh_bastion_tf"
  member  = "user:${var.email}"
}

resource "google_project_iam_member" "user_email-container_viewer" {
  project = var.project
  role    = "roles/container.viewer"
  member  = "user:${var.email}"
}
