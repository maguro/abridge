variable "cidr_prefix_lengths" {
  description = "CIDR prefix lengths for VPC cluster"
  type = object({
    nodes    = number
    pods     = number
    services = number
  })
}

variable "cluster" {
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

variable "enable_vertical_pod_autoscaling" {
  description = "Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it."
  type        = bool
  default     = false
}

variable "env" {
  description = "Environment being managed"
  type        = string
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

variable "vpc_network_id" {
  description = "The ID of the VPC network"
  type        = string
}
