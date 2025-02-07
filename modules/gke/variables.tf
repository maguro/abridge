variable "cidr_prefix_lengths" {
  description = "CIDR prefix lengths for VPC cluster"
  type = object({
    nodes_prefix_length    = number
    pods_prefix_length     = number
    services_prefix_length = number
  })
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "deletion_protection" {
  description = <<EOF
    Whether Terraform will be prevented from destroying the cluster.
    Deleting this cluster via terraform destroy or terraform apply will only
    succeed if this field is false in the Terraform state, i.e. you must
    explicitly set deletion_protection = false and run terraform apply
    to write the field to state in order to destroy a cluster.
    EOF
  type        = bool
  default     = true
}

variable "env" {
  description = "Environment being managed"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "AutoPilot GKE master CIDR"
  type        = string
  default     = "10.100.100.0/28"
}

variable "node_locations" {
  description = "Zone hosting GKE installation"
  type        = list(string)
  default = [
    "us-central1-a",
    "us-central1-b"
  ]
}

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools"

  default = []
}

variable "project" {
  description = "Project hosting cluster"
  type        = string
}

variable "region" {
  description = "Location hosting GKE cluster region"
  type        = string
  default     = "us-central1"
}

variable "vpc" {
  description = "The name of the VPC network"
  type        = string
}
