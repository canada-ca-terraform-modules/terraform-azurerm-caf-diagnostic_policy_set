variable "env" {
  description = "You can use a prefix to add to the list of resource groups you want to create"
  type        = string
}

variable "userDefinedString" {
  description = "UserDefinedString part of the name of the resource"
  type        = string
}

variable "log_analytics_workspace" {
  description = "Log analytics workspace object"
  type        = any
}

variable "management_group_name" {
  description = "The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "policy_name_postfix" {
  description = "The postfix value to append at the end of the generated resource name"
  type        = string
  default     = ""
}