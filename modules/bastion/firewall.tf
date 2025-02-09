// Allow access to the Bastion Host via SSH.
resource "google_compute_firewall" "bastion-iap-ssh" {
  name      = "a5e-${var.env}-${var.cluster_name}-bastion-iap-ssh-tf"
  network   = var.vpc_network_id
  direction = "INGRESS"
  project   = var.project

  // Google IAP CIDR range
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["a5e-${var.env}-${var.cluster_name}-bastion-tf"]
}
