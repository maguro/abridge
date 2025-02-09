variable "env" {
  description = "Environment being managed"
  type        = string
}

variable "project" {
  description = "GCP project hosting cluster"
  type        = string
}

variable "cluster" {
  description = "Name of the GKE cluster bastion is associated with"
  type        = string
}

variable "zone" {
  description = "Zone of bastion"
  type        = string
  default     = "us-central1-c"
}

variable "email" {
  description = "Google email address of user being granted bastion access"
  type        = string
}
