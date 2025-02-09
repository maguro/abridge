resource "google_container_cluster" "cluster" {
  provider = google

  count = local.autopilot_in_use ? 0 : 1

  name        = "a5e-${var.env}-${var.cluster}-tf"
  description = "Terraform managed GKE cluster, ${var.cluster}, for ${var.env} environment"

  deletion_protection = var.deletion_protection

  project        = var.project
  location       = var.region
  node_locations = var.node_locations

  network    = var.vpc_network_id
  subnetwork = google_compute_subnetwork.vpc_subnetwork.id

  ip_allocation_policy {
    cluster_secondary_range_name  = google_network_connectivity_internal_range.pods_ip_range.name
    services_secondary_range_name = google_network_connectivity_internal_range.services_ip_range.name
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  maintenance_policy {
    recurring_window {
      start_time = "2019-01-01T08:00:00Z"
      end_time   = "2019-01-01T16:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "${module.bastion_deployments.bastion_ip}/32"
      display_name = "External Control Plane access"
    }
  }
}

resource "google_container_node_pool" "pools" {
  for_each = local.node_pools

  name     = each.key
  project  = var.project
  location = var.region
  // use node_locations if provided, defaults to cluster level node_locations if not specified
  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null

  cluster = google_container_cluster.cluster[0].name

  node_count = lookup(each.value, "node_count", 1)

  node_config {
    machine_type = lookup(each.value, "machine_type", "e2-medium")

    service_account = lookup(
      each.value,
      "service_account",
      "${local.node_service_accounts[each.key]}@${var.project}.iam.gserviceaccount.com",
    )

    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")
  }
}