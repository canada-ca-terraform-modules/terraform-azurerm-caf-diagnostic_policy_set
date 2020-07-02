# https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/contoso/e2e-landing-zone-vwan-orchestration.parameters.json

locals {
  policies = {
    Deploy-Diagnostics-AA = {
      description = "Apply diagnostic settings for Azure Automation Accounts - Log Analytics"
    },
    Deploy-Diagnostics-ActivityLog = {
      description = "Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics"
    }
  }
}

resource "azurerm_policy_definition" "Deploy-Diagnostics" {
  for_each = local.policies

  name         = each.key
  policy_type  = "Custom"
  mode         = "All"
  display_name = each.key
  description  = each.value.description
  parameters   = file("${path.module}/policies/Deploy-Diagnostics-parameters.json")
  policy_rule  = file("${path.module}/policies/${each.key}.json")
}