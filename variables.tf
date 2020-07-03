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