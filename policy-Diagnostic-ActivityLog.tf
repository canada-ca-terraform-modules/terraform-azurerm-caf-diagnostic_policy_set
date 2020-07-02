# https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/contoso/e2e-landing-zone-vwan-orchestration.parameters.json

resource "azurerm_policy_definition" "Deploy-Diagnostics-ActivityLog" {
  # count        = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name         = "Deploy-Diagnostics-ActivityLog"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy-Diagnostics-ActivityLog"
  description  = "Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics"
  policy_rule  = file("policies/Deploy-Diagnostics-ActivityLog.json")
  parameters   = file("policies/Deploy-Diagnostics-parameters.json")
}