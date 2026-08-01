# Input variables for the module

variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group to deploy resources into."
  type        = string
}

variable "github_pat" {
  description = "GitHub personal access token used by API Center's Git repository integration to read the catalog repository. Stored in Key Vault as the 'github-apicenter-pat' secret."
  type        = string
  sensitive   = true
  default     = ""
}

variable "apicenter_git_repository_urls" {
  description = "Comma-separated list of Git repository URLs (each optionally including /tree/<branch>/<subfolder>) that API Center synchronizes skill/mcp-server/agent assets from. Leave empty to skip Git repository integration."
  type        = string
  default     = ""
}

variable "apicenter_apim_resource_ids" {
  description = "Comma-separated list of resource IDs of existing Azure API Management instances for API Center to synchronize APIs from. Leave empty to skip API Management integration."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_name" {
  description = "Name of the existing Log Analytics workspace, in resource_group_name, that Key Vault diagnostic logs (all categories) and metrics are sent to. Leave empty to skip diagnostic settings."
  type        = string
}
