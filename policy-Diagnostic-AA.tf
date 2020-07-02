# https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/contoso/e2e-landing-zone-vwan-orchestration.parameters.json

resource "azurerm_policy_definition" "Deploy-Diagnostics-AA" {
  # count        = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name         = "Deploy-Diagnostics-AA"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy-Diagnostics-AA"
  description  = "Apply diagnostic settings for Azure Automation Accounts - Log Analytics"
  parameters   = file("policies/Deploy-Diagnostics-parameters.json")
  policy_rule  = file("policies/Deploy-Diagnostics-AA.json")
}