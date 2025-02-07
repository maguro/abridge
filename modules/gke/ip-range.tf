resource "google_network_connectivity_internal_range" "nodes_ip_range" {
  name          = "a5e-${var.env}-${var.cluster_name}-nodes-tf"
  project       = var.project
  network       = "projects/${var.project}/global/networks/a5e-${var.env}-${var.vpc}-tf"
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  prefix_length = var.cidr_prefix_lengths.nodes_prefix_length
}

resource "google_network_connectivity_internal_range" "pods_ip_range" {
  name          = "a5e-${var.env}-${var.cluster_name}-pods-tf"
  project       = var.project
  network       = "projects/${var.project}/global/networks/a5e-${var.env}-${var.vpc}-tf"
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  prefix_length = var.cidr_prefix_lengths.pods_prefix_length
}

resource "google_network_connectivity_internal_range" "services_ip_range" {
  name          = "a5e-${var.env}-${var.cluster_name}-services-tf"
  project       = var.project
  network       = "projects/${var.project}/global/networks/a5e-${var.env}-${var.vpc}-tf"
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  prefix_length = var.cidr_prefix_lengths.services_prefix_length
}
