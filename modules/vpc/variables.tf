variable "project" {
  description = "Project hosting cluster"
  type        = string
}

variable "env" {
  description = "Environment being managed"
  type        = string
}

variable "vpc" {
  description = "The name of the VPC network"
  type        = string
}

variable "routing_mode" {
  description = "The network-wide routing (REGIONAL/GLOBAL)"
  type        = string
  default     = "GLOBAL"
}
