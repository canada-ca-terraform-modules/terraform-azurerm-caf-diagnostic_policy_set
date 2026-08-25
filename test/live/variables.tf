variable "env" {
  description = "Environment prefix used by the module under test"
  type        = string
  default     = "livetest"
}

variable "pr_number" {
  description = <<-EOT
    Suffix folded into policy_name_postfix so concurrent PRs against this
    module never collide on the same subscription-scoped policy definition
    names. CI sources this from `TF_VAR_pr_number` (`github.event.number`);
    manual runs can leave the default or pass their own value.
  EOT
  type        = string
  default     = "manual"
}

variable "log_analytics_workspace" {
  description = "Log analytics workspace object, passed straight through to the module under test"
  type        = any
  default     = {}
}

variable "management_group_id" {
  description = "Management group scope for the policy/policy-set definitions. Left null to exercise the module's default subscription scope."
  type        = string
  default     = null
}

variable "policy_name_postfix" {
  description = "Base postfix appended to every generated policy/policy-set name, before the pr_number suffix"
  type        = string
  default     = ""
}
