output "id" {
  description = "The resource ID of the API Center service"
  value       = azapi_resource.apic.id
}

output "name" {
  description = "The name of the API Center service"
  value       = azapi_resource.apic.name
}

output "principal_id" {
  description = "The principal ID of the API Center service's system-assigned managed identity"
  value       = azapi_resource.apic.identity[0].principal_id
}


output "portal_hostname" {
  description = "The hostname of the API Center portal"
  value       = azapi_resource.apic.output.properties.portalHostname
}
