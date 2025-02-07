locals {
  required_labels = {
    "env"     = var.env
    "project" = var.project
  }
  owner_label = {
    "owner" = var.owner
  }
  service_label = {
    "service" = var.service
  }
  all_labels = merge(local.required_labels, local.owner_label, local.service_label)
}
