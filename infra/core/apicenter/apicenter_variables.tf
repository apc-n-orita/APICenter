# Input variables for the module

variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_id" {
  description = "The resource ID of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "name" {
  description = "The name of the API Center service (typically CAF-named by the caller)."
  type        = string
}

variable "sku_name" {
  description = "The pricing tier of the API Center service. Possible values are Free and Standard."
  type        = string
  default     = "Free"
}
