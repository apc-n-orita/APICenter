output "git_source_ids" {
  description = "Resource IDs of the Git-backed API sources, one per entry in var.git_repository_urls"
  value       = [for src in azapi_resource.apic_git_source : src.id]
}

output "git_environment_id" {
  description = "The resource ID of the environment representing linked Git repositories"
  value       = azapi_resource.apic_git_environment.id
}

output "apim_source_ids" {
  description = "Resource IDs of the API Management-backed API sources, one per entry in var.apim_resource_ids"
  value       = [for src in azapi_resource.apic_apim_source : src.id]
}

output "apim_environment_id" {
  description = "The resource ID of the environment representing linked API Management instances"
  value       = azapi_resource.apic_apim_environment.id
}
