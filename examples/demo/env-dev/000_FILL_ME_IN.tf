terraform {
  backend "gcs" {
    ##
    ## DEMO: Change to GCS bucket for dev Terraform state.
    ##
    bucket = "a5e-state-dev-tf"
    ##

    prefix = "base"
  }
}

variable "project" {
  description = "Project hosting cluster"
  type        = string

  ##
  ## DEMO: Change to the GCP project hosting the cluster
  ##
  default = "abridge-takehome"
  ##
}

variable "bastion_account" {
  description = "The Operator Account email to connect to Bastion VMs."
  type        = string

  ##
  ## DEMO: Replace w/ desired Operator Account email
  ##
  default = "alan.cabrera@gmail.com"
  ##
}