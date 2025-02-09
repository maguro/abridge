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

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance."
  type        = bool
  default     = true
}
