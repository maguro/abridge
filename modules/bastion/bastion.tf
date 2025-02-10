locals {
  hostname = "a5e-${var.env}-${var.cluster}-bastion-tf"
}

/*
  This is needed to gain access to the internet to install tinyproxy.
  Ideally, the bastion image would have it installed so that this public IP
  address isn't needed.  With that said, IAP still protects access to the
  bastion.
 */
resource "google_compute_address" "static" {
  name    = "a5e-${var.env}-${var.cluster}-bastion-ip-tf"
  project = var.project
  region  = var.region
}

/*
  The Bastion host.
 */
resource "google_compute_instance" "bastion" {
  name    = local.hostname
  project = var.project
  labels  = merge(var.required_labels, local.label_owner_shared, local.label_products_shared)

  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["a5e-${var.env}-${var.cluster}-bastion-tf"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  // Install
  // - tinyproxy: used by helm and k8s
  // - locales
  metadata_startup_script = file("${path.module}/bastion_startup.sh")

  network_interface {
    network    = var.vpc_network_id
    subnetwork = var.vpc_subnetwork_id
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  // Allow the instance to be stopped by Terraform when updating configuration.
  allow_stopping_for_update = true

  service_account {
    email  = google_service_account.bastion_service_account.email
    scopes = ["cloud-platform"]
  }

  /* local-exec providers may run before the host has fully initialized.
  However, they are run sequentially in the order they were defined.
  This provider is used to block the subsequent providers until the instance is available. */
  provisioner "local-exec" {
    command = <<EOF
        READY=""
        for i in $(seq 1 20); do
          if gcloud compute ssh ${local.hostname} --tunnel-through-iap --project ${var.project} --zone ${var.zone} --command uptime; then
            READY="yes"
            break;
          fi
          echo "Waiting for ${local.hostname} to initialize..."
          sleep 10;
        done
        if [[ -z $READY ]]; then
          echo "${local.hostname} failed to start in time."
          echo "Please verify that the instance starts and then re-run `terraform apply`"
          exit 1
        fi
EOF
  }

  scheduling {
    preemptible       = false
    automatic_restart = true
  }

  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"]
    ]
  }
}
