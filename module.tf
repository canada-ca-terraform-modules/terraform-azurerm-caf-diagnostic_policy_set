# https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/contoso/armTemplates/auxiliary/policies.json

data azurerm_subscription primary {}

locals {
  policy_set_name = var.management_group_name == null ? substr("${var.env}-${var.userDefinedString} diagnostic initiative", 0, 64) : "Deploy-Diagnostic-Initiative"
  subscriptionID  = data.azurerm_subscription.primary.subscription_id
  policies_json   = file("${path.module}/policies/all-Diagnostics-Policies.json")
  policies = {
    for policy in jsondecode(local.policies_json) :
    policy.Name => {
      name        = "${policy.Name}${var.policy_name_postfix}"
      description = try(policy.Properties.description, "")
      policyRule  = policy.Properties.policyRule
    }
  }
}

resource "azurerm_policy_definition" "policy_definition" {
  for_each = local.policies
  # No need for count since we handle the the local.policies content at the local file read time
  name                  = each.value.name
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = each.value.name
  description           = each.value.description
  management_group_name = var.management_group_name == null ? null : var.management_group_name
  parameters            = file("${path.module}/policies/Deploy-Diagnostics-parameters.json")
  policy_rule           = jsonencode(each.value.policyRule)
}

resource "azurerm_policy_set_definition" "policy_set_definition" {
  depends_on            = [azurerm_policy_definition.policy_definition]
  name                  = "${local.policy_set_name}${var.policy_name_postfix}"
  policy_type           = "Custom"
  display_name          = "${local.policy_set_name}${var.policy_name_postfix}"
  description           = "This initiative configures application Azure resources to forward diagnostic logs and metrics to an Azure Log Analytics workspace."
  management_group_name = var.management_group_name == null ? null : var.management_group_name
  parameters            = file("${path.module}/policies/Deploy-Diagnostics-parameters.json")
  dynamic "policy_definition_reference" {
    for_each = jsondecode(local.policies_json)
    content {
      parameter_values = {
        "logAnalytics" = "[parameters('logAnalytics')]"
        "prefix"       = "[parameters('prefix')]"
      }
      policy_definition_id = var.management_group_name == null ? "/subscriptions/${local.subscriptionID}/providers/Microsoft.Authorization/policyDefinitions/${policy_definition_reference.value.Name}${var.policy_name_postfix}" : "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/${policy_definition_reference.value.Name}${var.policy_name_postfix}"
    }
  }
}
