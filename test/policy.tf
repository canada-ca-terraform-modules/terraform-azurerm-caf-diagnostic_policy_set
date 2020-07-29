data azurerm_subscription primary {}

module Project-Diagnostic-Policy {
  source                  = "../."
  deploy                  = true
  env                     = local.env
  userDefinedString       = local.prefix
  log_analytics_workspace = local.Project-law
  policy_name_postfix     = "-test"
}
/*
module Management-Diagnostic-Policy {
  source                  = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-diagnostic_policy_set?ref=v0.1.9"
  deploy                  = local.deployOptionalFeatures.diagnostics_policy
  env                     = local.env
  userDefinedString       = local.prefix
  log_analytics_workspace = local.Project-law
  management_group_name   = "PBMM_VDC"
}
*/
locals {
  policy_set_name = substr("${local.env}-${local.prefix} diagnostic policy set", 0, 64)
}

resource "azurerm_policy_assignment" "policy_assignment" {
  name                 = local.policy_set_name
  location             = local.Project-law.location
  scope                = data.azurerm_subscription.primary.id
  policy_definition_id = module.Project-Diagnostic-Policy.policy_set_definition.id
  display_name         = local.policy_set_name
  description          = "Apply diagnostic settings on subscription for Azure for PBMM Guardrails compliance"
  identity {
    type = "SystemAssigned"
  }
  parameters = <<PARAMETERS
  {
    "logAnalytics": {
      "value": "${local.Project-law.id}"
    },
    "prefix": {
      "value": "${local.Project-law.name}-"
    }
  }
PARAMETERS
}
