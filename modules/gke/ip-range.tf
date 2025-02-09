##
## Reserve IP ranges for
## - nodes
## - pods
## - services
##
resource "google_network_connectivity_internal_range" "nodes_ip_range" {
  name          = "a5e-${var.env}-${var.cluster}-nodes-tf"
  project       = var.project
  network       = var.vpc_network_id
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  prefix_length = var.cidr_prefix_lengths.nodes_prefix_length
}

resource "google_network_connectivity_internal_range" "pods_ip_range" {
  name          = "a5e-${var.env}-${var.cluster}-pods-tf"
  project       = var.project
  network       = var.vpc_network_id
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  prefix_length = var.cidr_prefix_lengths.pods_prefix_length
}

resource "google_network_connectivity_internal_range" "services_ip_range" {
  name          = "a5e-${var.env}-${var.cluster}-services-tf"
  project       = var.project
  network       = var.vpc_network_id
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  prefix_length = var.cidr_prefix_lengths.services_prefix_length
}
