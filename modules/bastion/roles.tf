resource "google_project_iam_custom_role" "ssh_bastion_role" {
  role_id     = "a5e_${var.env}_${var.cluster}_ssh_bastion_tf"
  project     = var.project
  title       = "ABridge bastion ssh role for ${var.cluster} in ${var.env}"
  description = "Terraform managed bastion ssh role for ${var.cluster} in ${var.env}"

  permissions = [
    "compute.instances.get",
    "compute.projects.get"
  ]
}
