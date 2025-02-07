module "dev_environment" {
  source = "../env-template"

  deletion_protection = var.deletion_protection

  env                      = "dev"
  project                  = var.project
  region                   = var.region
  private_ip_google_access = var.private_ip_google_access
  master_ipv4_cidr_block   = var.master_ipv4_cidr_block
}
