resource "google_compute_subnetwork" "vpc_subnetwork" {
  name                     = "a5e-${var.env}-${var.vpc}-${var.cluster_name}-tf"
  description              = "Terraform managed subnet"
  project                  = var.project
  network                  = var.vpc_network_id
  region                   = var.region
  private_ip_google_access = true

  reserved_internal_range = "networkconnectivity.googleapis.com/${google_network_connectivity_internal_range.nodes_ip_range.id}"

  secondary_ip_range {
    range_name              = "a5e-${var.env}-${var.cluster_name}-services-tf"
    reserved_internal_range = "networkconnectivity.googleapis.com/${google_network_connectivity_internal_range.services_ip_range.id}"
  }

  secondary_ip_range {
    range_name              = "a5e-${var.env}-${var.cluster_name}-pods-tf"
    reserved_internal_range = "networkconnectivity.googleapis.com/${google_network_connectivity_internal_range.pods_ip_range.id}"
  }
}
