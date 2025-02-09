locals {
  team_ml          = "ml"
  section_training = "train"
}

module "vpc_ml" {
  source  = "../../../modules/vpc"
  env     = var.env
  vpc     = local.team_ml
  project = var.project
}

module "gke_cluster" {
  source              = "../../../modules/gke"
  deletion_protection = var.deletion_protection
  cluster_name        = local.section_training
  project             = var.project
  env                 = var.env
  vpc                 = local.team_ml
  vpc_network_id      = module.vpc_ml.vpc_network_id

  cidr_prefix_lengths = {
    nodes_prefix_length    = 16
    pods_prefix_length     = 16
    services_prefix_length = 24
  }

  # node_pools = [
  #   {
  #     name         = "pool-01"
  #     node_count   = 1
  #     disk_size_gb = 15
  #     auto_upgrade = true
  #   },
  #   {
  #     name            = "pool-02"
  #     machine_type    = "e2-micro"
  #     node_count      = 1
  #     disk_size_gb    = 15
  #     disk_type       = "pd-balanced"
  #     service_account = google_service_account.special_service_account.email
  #   },
  #   {
  #     name           = "pool-03"
  #     machine_type    = "e2-micro"
  #     disk_size_gb    = 20
  #     node_locations = "${var.region}-b,${var.region}-c"
  #     disk_type      = "pd-standard"
  #   },
  # ]

  depends_on = [
    module.vpc_ml,
    google_service_account.special_service_account,
  ]
}
