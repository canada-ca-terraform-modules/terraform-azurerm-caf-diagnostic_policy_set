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

variable "management_group_name" {
  description = "(Optional) The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "policy_name_postfix" {
  type    = string
  default = ""
}