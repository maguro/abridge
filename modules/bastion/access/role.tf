/*
  Needed to allow `gcloud compute ssh` bastion.
 */
resource "google_project_iam_member" "user_email-ssh_bastion" {
  project = var.project
  role    = "projects/${var.project}/roles/a5e_${var.env}_${var.cluster}_ssh_bastion_tf"
  member  = "user:${var.email}"
}

/*
  Needed to allow `gcloud container clusters get-credentials` to be executed.
  This is needed to run `kubectl` against the cluster that the bastion is
  associated with.
 */
resource "google_project_iam_member" "user_email-container_viewer" {
  project = var.project
  role    = "roles/container.viewer"
  member  = "user:${var.email}"
}

/*
  N.B. These two roles are separate because the former is concerned with
  shelling into the bastion, to create an SSH tunnel, and the latter is
  concerned with what one does when an SSH tunnel has been created.
 */