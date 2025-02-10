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

variable "node_pools_overrides" {
  type = map(map(any))

  # Default is being set in variables_defaults.tf
  default = {
    all               = {}
    default-node-pool = {}
  }
}
