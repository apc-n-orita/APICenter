variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "name" {
  description = "The name of the key vault (typically CAF-named by the caller, e.g. via azurecaf_name)."
  type        = string
}

variable "principal_id" {
  description = "The Id of the principal to grant the 'Key Vault Secrets Officer' RBAC role (read/write secrets)."
  type        = string
}

variable "secrets_user_object_ids" {
  description = "A list of object ids to grant the 'Key Vault Secrets User' RBAC role (read-only secrets access)."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace to send Key Vault diagnostic logs (all log categories) and metrics to. Set to an empty string to skip diagnostic settings."
  type        = string
}

variable "secrets" {
  description = "A list of secrets to be added to the keyvault"
  type = list(object({
    name  = string
    value = string
  }))
  sensitive = true
}
