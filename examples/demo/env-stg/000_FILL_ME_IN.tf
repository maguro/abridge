terraform {
  backend "gcs" {
    ##
    ## DEMO: Change to GCS bucket for dev Terraform state.
    ##
    bucket = "a5e-state-stg-tf"
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
