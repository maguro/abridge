variable "env" {
  description = "Environment being managed"
  type        = string
}

variable "project" {
  description = "Project hosting cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "Location hosting CloudRun installation"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone of bastion"
  type        = string
  default     = "us-central1-c"
}


variable "required_labels" {
  description = "Labels to apply to infrastructure resources"
  type        = map(string)
}
variable "vpc" {
  description = "The name of the VPC network"
  type        = string
}


variable "vpc_network_id" {
  description = "The name of the VPC network"
  type        = string
}

variable "vpc_subnetwork_id" {
  description = "The name of the VPC subnetwork"
  type        = string
}
