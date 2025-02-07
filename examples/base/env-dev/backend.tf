terraform {
  backend "gcs" {
    bucket = "a5e-state-stg-tf"
    prefix = "base"
  }
}
