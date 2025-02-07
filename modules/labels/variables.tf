variable "project" {
  description = "The GCP project id"
  type        = string
}

variable "env" {
  description = "The short-hand environment name"
  type        = string
}

variable "service" {
  description = "The service name to use in the naming of resources"
  type        = string
  default     = "unknown"
}

variable "owner" {
  description = "The email of the team that owns this IAC resource without the domain i.e. who should be contacted for changes/issues"
  type        = string
  default     = "unknown"
}
