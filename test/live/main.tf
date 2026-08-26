terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }

  # Empty on purpose: the state file path is supplied at `terraform init`
  # time via `-backend-config="path=..."` (partial configuration), so the
  # target-branch checkout and the PR-branch checkout can point at the same
  # external state file without either owning its own local state.
  backend "local" {}
}

provider "azurerm" {
  storage_use_azuread             = true
  resource_provider_registrations = "legacy"
  features {}
}

module "diagnostic_policy_set" {
  # PR code and baseline code are two on-disk checkouts of this same repo,
  # not two resolved git refs - no pinned ?ref, no version toggle here.
  source = "../../"

  env                     = var.env
  userDefinedString       = "livetest"
  log_analytics_workspace = var.log_analytics_workspace
  management_group_id     = var.management_group_id
  # pr_number is folded in here (not the tfvars fixture) because policy
  # definitions are subscription-scoped by name alone - two concurrently
  # open PRs against this module would otherwise create identically named
  # azurerm_policy_definition resources and collide.
  policy_name_postfix = "${var.policy_name_postfix}-${var.pr_number}"
}
