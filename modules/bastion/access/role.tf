resource "google_project_iam_member" "user_email-ssh_bastion" {
  project = var.project
  role    = "projects/${var.project}/roles/a5e_${var.env}_${var.cluster_name}_ssh_bastion_tf"
  member  = "user:${var.email}"
}
