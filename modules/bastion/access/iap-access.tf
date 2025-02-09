##
## Adds an entry that allows the user
##
resource "google_iap_tunnel_instance_iam_member" "member" {
  project  = var.project
  zone     = var.zone
  instance = "a5e-${var.env}-${var.cluster}-bastion-tf"
  role     = "roles/iap.tunnelResourceAccessor"
  member   = "user:${var.email}"
}
