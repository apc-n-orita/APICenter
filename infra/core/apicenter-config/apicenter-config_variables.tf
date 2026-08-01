# Input variables for the module

variable "apic_id" {
  description = "The resource ID of the API Center service to configure (output of the apicenter module)."
  type        = string
}

variable "apic_principal_id" {
  description = "The principal ID of the API Center service's system-assigned managed identity (output of the apicenter module)."
  type        = string
}

variable "name_suffix" {
  description = "A short suffix string (e.g. the first 3 characters of the root module's resource_token) to centrally mitigate resource name collisions."
  type        = string
}

variable "enable_mcp_endpoint" {
  description = "Enable the API Center data-plane MCP endpoint used to discover registered MCP servers."
  type        = bool
  default     = false
}

variable "enable_marketplace_endpoint" {
  description = "Enable the API Center plugin marketplace data-plane endpoint."
  type        = bool
  default     = false
}

variable "visibility_asset_kinds" {
  description = "Asset 'kind' values made visible through the API Center data-plane API (portal, consumption features). Set to an empty list to make every asset visible."
  type        = list(string)
  default     = ["mcp", "skill", "plugin", "agent"]
}

variable "git_repository_urls" {
  description = "URLs of Git repositories to synchronize API Center assets from, each optionally including /tree/<branch>/<subfolder>. One apiSource is created per URL. Set to an empty list to skip Git repository integration."
  type        = list(string)
  default     = []
}


variable "git_import_specification" {
  description = "Whether to import the specification file along with metadata for assets synchronized from Git. One of: always, never, ondemand."
  type        = string
  default     = "ondemand"
}

variable "git_pat_secret_uri" {
  description = "Key Vault secret URI (e.g. https://<vault>.vault.azure.net/secrets/<name>) holding the Git personal access token used to authenticate to the repositories. Applied to every URL in git_repository_urls. Leave empty for public repositories."
  type        = string
  default     = ""
  sensitive   = true
}

variable "apim_resource_ids" {
  description = "Resource IDs of existing Azure API Management instances to synchronize APIs from. One apiSource is created per resource ID. Set to an empty list to skip API Management integration. The API Center service's managed identity must be granted the 'API Management Service Reader Role' on each instance (see the apicenter_apim_reader role assignment in the root module)."
  type        = list(string)
  default     = []
}

variable "apim_import_specification" {
  description = "Whether to import the specification file along with metadata for APIs synchronized from API Management. One of: always, never, ondemand."
  type        = string
  default     = "always"
}
