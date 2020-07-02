# https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/contoso/e2e-landing-zone-vwan-orchestration.parameters.json

resource "azurerm_policy_definition" "Deploy-Diagnostics-VMSS" {
  # count        = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name         = "Deploy-Diagnostics-VMSS"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy-Diagnostics-VMSS"
  description  = "Apply diagnostic settings for Azure VMSS - Log Analytics"
  policy_rule  = file("${path.module}/policies/Deploy-Diagnostics-VMSS.json")
  parameters   = file("${path.module}/policies/Deploy-Diagnostics-parameters.json")
}