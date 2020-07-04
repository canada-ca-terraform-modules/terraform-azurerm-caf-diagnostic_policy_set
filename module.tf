data "azurerm_subscription" "primary" {}

locals {
  policy_set_name = substr("${var.env}-${var.userDefinedString} diagnostic policy set", 0, 64)
  policies = {
    Deploy-Diagnostics-AA = {
      description = "Apply diagnostic settings for Azure Automation Accounts - Log Analytics"
    },
    Deploy-Diagnostics-ActivityLog = {
      description = "Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics"
    },
    Deploy-Diagnostics-KeyVault = {
      description = "Apply diagnostic settings for Azure KeyVault - Log Analytics"
    },
    Deploy-Diagnostics-NIC = {
      description = "Apply diagnostic settings for Azure NIC - Log Analytics"
    },
    Deploy-Diagnostics-NSG = {
      description = "Apply diagnostic settings for Azure NSG - Log Analytics"
    },
    Deploy-Diagnostics-Recovery_Vault = {
      description = "Apply diagnostic settings for Azure Recovery Vault - Log Analytics"
    },
    Deploy-Diagnostics-VM = {
      description = "Apply diagnostic settings for Azure VM - Log Analytics"
    },
    Deploy-Diagnostics-VMSS = {
      description = "Apply diagnostic settings for Azure VM Scale Set - Log Analytics"
    },
    Deploy-Diagnostics-VNET = {
      description = "Apply diagnostic settings for Azure VNET - Log Analytics"
    }
  }
}

resource "azurerm_policy_definition" "Deploy-Diagnostics" {
  for_each = var.deploy ? local.policies : {}

  name         = each.key
  policy_type  = "Custom"
  mode         = "All"
  display_name = each.key
  description  = each.value.description
  parameters   = file("${path.module}/policies/Deploy-Diagnostics-parameters.json")
  policy_rule  = file("${path.module}/policies/${each.key}.json")
}

resource "azurerm_policy_set_definition" "policy_set_definition" {
  count              = var.deploy ? 1 : 0
  name               = local.policy_set_name
  policy_type        = "Custom"
  display_name       = local.policy_set_name
  parameters         = <<PARAMETERS
  {
    "logAnalytics": {
        "type": "String",
        "defaultValue": ""
    },
    "prefix": {
        "type": "String",
        "defaultValue": ""
    }
  }
PARAMETERS
  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/policyDefinitions/Deploy-Diagnostics-AA')]"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-ActivityLog"].id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-KeyVault"].id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-NIC"].id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-NSG"].id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-Recovery_Vault"].id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-VNET"].id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-VM"].id}"
        },
        {
            "parameters": {
                "logAnalytics": {
                    "value": "[parameters('logAnalytics')]"
                },
                "prefix": {
                    "value": "[parameters('prefix')]"
                }
            },
            "policyDefinitionId": "${azurerm_policy_definition.Deploy-Diagnostics["Deploy-Diagnostics-VMSS"].id}"
        }
    ]
POLICY_DEFINITIONS
}

resource "azurerm_policy_assignment" "policy_assignment" {
  count                = var.deploy ? 1 : 0
  name                 = local.policy_set_name
  location             = var.log_analytics_workspace.location
  scope                = data.azurerm_subscription.primary.id
  policy_definition_id = azurerm_policy_set_definition.policy_set_definition[0].id
  display_name         = local.policy_set_name
  description          = "Apply diagnostic settings for Azure for PBMM Guardrails compliance"
  identity {
    type = "SystemAssigned"
  }
  parameters = <<PARAMETERS
  {
    "logAnalytics": {
      "value": "${var.log_analytics_workspace.id}"
    },
    "prefix": {
      "value": "${var.log_analytics_workspace.name}-"
    }
  }
PARAMETERS
}