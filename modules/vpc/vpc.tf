resource "google_compute_network" "vpc_network" {
  name                    = "a5e-${var.env}-${var.vpc}-tf"
  description             = "Terraform managed VPC for ${var.vpc}'s ${var.env} environment"
  project                 = var.project
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}
