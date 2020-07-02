# https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/contoso/e2e-landing-zone-vwan-orchestration.parameters.json

resource "azurerm_policy_definition" "Deploy-Diagnostics-ActivityLog" {
  # count        = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name         = "Deploy-Diagnostics-ActivityLog"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy-Diagnostics-ActivityLog"
  description  = "Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics"
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Insights/diagnosticSettings",
        "deploymentScope": "Subscription",
        "existenceScope": "Subscription",
        "existenceCondition": {
          "allOf": [
            {
              "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
              "equals": "true"
            },
            {
              "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
              "equals": "[parameters('logAnalytics')]"
            }
          ]
        },
        "deployment": {
          "location": "[parameters('location')]",
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "logAnalytics": {
                  "type": "string"
                }
              },
              "variables": {},
              "resources": [
                {
                  "name": "${var.log_analytics_workspace.name}-setByPolicy",
                  "type": "Microsoft.Insights/diagnosticSettings",
                  "apiVersion": "2017-05-01-preview",
                  "location": "Global",
                  "properties": {
                    "workspaceId": "[parameters('logAnalytics')]",
                    "logs": [
                      {
                        "category": "Administrative",
                        "enabled": true
                      },
                      {
                        "category": "Security",
                        "enabled": true
                      },
                      {
                        "category": "ServiceHealth",
                        "enabled": true
                      },
                      {
                        "category": "Alert",
                        "enabled": true
                      },
                      {
                        "category": "Recommendation",
                        "enabled": true
                      },
                      {
                        "category": "Policy",
                        "enabled": true
                      },
                      {
                        "category": "Autoscale",
                        "enabled": true
                      },
                      {
                        "category": "ResourceHealth",
                        "enabled": true
                      }
                    ]
                  }
                }
              ],
              "outputs": {}
            },
            "parameters": {
              "logAnalytics": {
                "value": "[parameters('logAnalytics')]"
              },
              "location": {
                "value": "[field('location')]"
              }
            }
          }
        },
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
        ]
      }
    }
  }
POLICY_RULE
  parameters   = <<PARAMETERS
  {
    "logAnalytics": {
      "type": "String",
      "metadata": {
        "displayName": "Log Analytics workspace",
        "description": "Select the Log Analytics workspace from dropdown list",
        "strongType": "omsWorkspace"
      }
    }
  }
PARAMETERS
}
/*
resource "azurerm_policy_assignment" "Deploy-Diagnostics-ActivityLog" {
  # count                = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name                 = "Deploy-Diagnostics-ActivityLog"
  location             = var.log_analytics_workspace.location
  scope                = data.azurerm_subscription.primary.id
  policy_definition_id = azurerm_policy_definition.Deploy-Diagnostics-ActivityLog.id
  display_name         = "Deploy-Diagnostics-ActivityLog"
  description          = "Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics"
  identity {
    type = "SystemAssigned"
  }
  parameters = <<PARAMETERS
  {
    "logAnalytics": {
      "value": "${var.log_analytics_workspace.id}"
    }
  }
PARAMETERS
}

resource "azurerm_policy_remediation" "Deploy-Diagnostics-ActivityLog" {
  name                 = lower("Deploy-Diagnostics-ActivityLog-policy-remediation")
  scope                = azurerm_policy_assignment.Deploy-Diagnostics-ActivityLog.scope
  policy_assignment_id = azurerm_policy_assignment.Deploy-Diagnostics-ActivityLog.id
  # location_filters     = ["West Europe"]
}
*/