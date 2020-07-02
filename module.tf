data "azurerm_subscription" "primary" {}

locals {
  policy_set_name = substr("${var.env}-${var.userDefinedString} diagnostic policy set", 0, 64)
}

resource "azurerm_policy_set_definition" "policy_set_definition" {
  name         = local.policy_set_name
  policy_type  = "Custom"
  display_name = local.policy_set_name

  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-AA.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-ActivityLog.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-KeyVault.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-NIC.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-NSG.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-Recovery_Vault.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-VNET.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-VM.id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "${var.log_analytics_workspace.id}"
                },
                "prefix": {
                    "value": "${var.log_analytics_workspace.name}-"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics-VMSS.id}"
        }
    ]
POLICY_DEFINITIONS
}

resource "azurerm_policy_assignment" "policy_assignment" {
  # count                = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name                 = local.policy_set_name
  location             = var.log_analytics_workspace.location
  scope                = data.azurerm_subscription.primary.id
  policy_definition_id = azurerm_policy_set_definition.policy_set_definition.id
  display_name         = local.policy_set_name
  description          = "Apply diagnostic settings for Azure for PBMM Guardrails compliance"
  identity {
    type = "SystemAssigned"
  }
}