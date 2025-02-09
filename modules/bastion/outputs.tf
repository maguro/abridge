output "instance" {
  value       = google_compute_instance.bastion
  description = "The bastion instance"
}

output "bastion_ip" {
  description = "Bastion IP address"
  value       = google_compute_instance.bastion.network_interface.0.network_ip
}