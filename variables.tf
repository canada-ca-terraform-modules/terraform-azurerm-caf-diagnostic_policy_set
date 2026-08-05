variable "env" {
  description = "You can use a prefix to add to the list of resource groups you want to create"
  type        = string
}

variable "userDefinedString" {
  description = "UserDefinedString part of the name of the resource"
  type        = string
}

# Required for backward compat: policy assignment (where this value is actually consumed
# as a Log Analytics parameter) was deliberately moved out of this module in v0.1.8 so
# callers assign it separately; kept required here so existing module blocks don't break.
# tflint-ignore: terraform_unused_declarations
variable "log_analytics_workspace" {
  description = "Log analytics workspace object"
  type        = any
}

variable "management_group_id" {
  description = "The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "policy_name_postfix" {
  description = "The postfix value to append at the end of the generated resource name"
  type        = string
  default     = ""
}

variable "policy_set_definition_name" {
  description = "(Optional) Override the auto-generated Policy Set Definition name/display name (before policy_name_postfix is appended). When null, the name is computed from management_group_id, env and userDefinedString."
  type        = string
  default     = null
}
