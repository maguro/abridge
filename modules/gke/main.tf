locals {
  node_pool_names = [for np in toset(var.node_pools) : np.name]
  node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))

  autopilot_in_use    = length(var.node_pools) == 0
  node_service_keys   = local.autopilot_in_use ? ["autopilot"] : local.node_pool_names
  node_service_emails = local.autopilot_in_use ? ["a5e-${var.env}-${var.cluster}-autopilot-tf"] : [for np in toset(var.node_pools) : "a5e-${var.env}-${var.cluster}-${np.name}-pool-tf"]

  node_service_accounts = zipmap(local.node_service_keys, local.node_service_emails)
}

module "bastion_deployments" {
  source            = "../bastion"
  env               = var.env
  cluster      = var.cluster
  project           = var.project
  region            = var.region
  vpc               = var.vpc
  vpc_network_id    = var.vpc_network_id
  vpc_subnetwork_id = google_compute_subnetwork.vpc_subnetwork.id
  required_labels   = {}

  depends_on = [google_compute_subnetwork.vpc_subnetwork]
}
