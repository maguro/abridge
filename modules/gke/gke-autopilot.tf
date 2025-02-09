resource "google_container_cluster" "autopilot" {
  provider = google

  count = local.autopilot_in_use ? 1 : 0

  name        = "a5e-${var.env}-${var.cluster}-tf"
  description = "Terraform managed GKE Autopilot cluster, ${var.cluster}, for ${var.env} environment. Deployed in the ${var.cluster} of the VPC ${var.vpc}."

  deletion_protection = var.deletion_protection

  project        = var.project
  location       = var.region
  node_locations = var.node_locations

  network    = "projects/${var.project}/global/networks/a5e-${var.env}-${var.vpc}-tf"
  subnetwork = google_compute_subnetwork.vpc_subnetwork.id

  ip_allocation_policy {
    cluster_secondary_range_name  = google_network_connectivity_internal_range.pods_ip_range.name
    services_secondary_range_name = google_network_connectivity_internal_range.services_ip_range.name
  }

  initial_node_count = 1
  enable_autopilot   = true

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = "${local.node_service_accounts["autopilot"]}@${var.project}.iam.gserviceaccount.com"
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append",
      ]
    }
  }

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