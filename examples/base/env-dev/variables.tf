variable "project" {
  description = "Project hosting cluster"
  type        = string
  default     = "abridge-takehome"
}

variable "region" {
  description = "Region hosting installation"
  type        = string
  default     = "us-central1"
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance."
  type        = bool
  default     = true
}
