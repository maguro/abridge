variable "env" {
  description = "Environment being managed"
  type        = string
}

variable "project" {
  description = "Project hosting cluster"
  type        = string
}

variable "region" {
  description = "Location hosting CloudRun installation"
  type        = string
  default     = "us-central1"
}

variable "private_ip_google_access" {
  description = "When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access."
  type        = bool
}

variable "deployments_cidr" {
  description = "Deployments CIDR range"
  type        = string
  default     = "10.200.0.0/16"
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance."
  type        = bool
  default     = true
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet. See Private Cluster Limitations for more details. This field only applies to private clusters, when enable_private_nodes is true."
  type        = string
  default     = "10.100.100.0/28"
}
