output "required_labels" {
  description = "Map of strings with the generated required labels based on the input variables"
  value       = local.required_labels
}

output "service_label" {
  description = "Map of a single string with the service name to use in the naming of resources"
  value       = local.service_label
}

output "owner_label" {
  description = "Map of a single string with the email of the team that owns this IAC resource without the domain i.e. who should be contacted for changes/issues"
  value       = local.owner_label
}

output "all_labels" {
  description = "Map resulting from merging required_labels and all optional labels like `service` and `owner`"
  value       = local.all_labels
}

