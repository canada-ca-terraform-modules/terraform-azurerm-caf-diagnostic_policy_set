variable "env" {
  description = "Env"
  type        = string
}

variable "log_analytics_workspace" {
  description = "Log analytics workspace object"
}

variable "userDefinedString" {
  description = "User defined string for the module"
  type        = string
}

variable "deploy" {
  description = "Should resources be deployed"
  type        = bool
  default     = true
}

variable "scopeID" {
  description = "(Optional) Object ID of the scope to which the policy shoule be applied. Can be one of Management Group ID, Subscription ID or Resource Group ID. Default is the current Subscription ID."
  type        = string
  default     = null
}