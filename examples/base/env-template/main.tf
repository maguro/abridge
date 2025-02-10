locals {
  team_ml          = "ml"
  section_training = "train"
  section_front_end = "fe"
}

module "vpc_ml" {
  source  = "../../../modules/vpc"
  env     = var.env
  vpc     = local.team_ml
  project = var.project
}

module "front_end_cluster" {
  source              = "../../../modules/gke"
  deletion_protection = var.deletion_protection
  cluster             = local.section_front_end
  project             = var.project
  env                 = var.env
  vpc                 = local.team_ml
  vpc_network_id      = module.vpc_ml.vpc_network_id

  ##
  ## CIDR ranges are defined here
  ##
  cidr_prefix_lengths = {
    nodes_prefix_length    = 16
    pods_prefix_length     = 16
    services_prefix_length = 24
  }

  ##
  ## A cluster with zero node pools becomes a GKE Autopilot cluster
  ##
  node_pools = []
}

module "training_cluster" {
  source              = "../../../modules/gke"
  deletion_protection = var.deletion_protection
  cluster             = local.section_training
  project             = var.project
  env                 = var.env
  vpc                 = local.team_ml
  vpc_network_id      = module.vpc_ml.vpc_network_id

  ##
  ## CIDR ranges are defined here
  ##
  cidr_prefix_lengths = {
    nodes_prefix_length    = 16
    pods_prefix_length     = 16
    services_prefix_length = 24
  }

  node_pools = [
    {
      name         = "pool-01"
      node_count = 2
      disk_size_gb = 22

      auto_upgrade = true
    },
    {
      name            = "pool-02"
      machine_type    = "e2-micro"
      node_count      = 2
      disk_type       = "pd-balanced"
      service_account = google_service_account.special_service_account.email
    },
    {
      name           = "pool-03"
      machine_type    = "e2-micro"
      node_locations = "${var.region}-b,${var.region}-c"
      disk_type      = "pd-standard"
    },
  ]

  ##
  ## Allow environments to override node pool settings
  ##
  node_pools_overrides = var.node_pools_overrides
}
