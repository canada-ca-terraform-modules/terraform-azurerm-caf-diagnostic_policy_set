# https://github.com/Azure/Enterprise-Scale/blob/main/docs/reference/contoso/e2e-landing-zone-vwan-orchestration.parameters.json

resource "azurerm_policy_definition" "Deploy-Diagnostics-Recovery_Vault" {
  # count        = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name         = "Deploy-Diagnostics-Recovery_Vault"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy-Diagnostics-Recovery_Vault"
  description  = "Apply diagnostic settings for Azure Recovery Vault - Log Analytics"
  parameters   = <<PARAMETERS
  {
    "logAnalytics": {
      "type": "String",
      "metadata": {
        "displayName": "Log Analytics workspace",
        "description": "Select the Log Analytics workspace from dropdown list",
        "strongType": "omsWorkspace"
      }
    },
    "prefix": {
      "type": "String",
      "metadata": {
        "displayName": "Log Analytics workspace name prefix",
        "description": "(Optional) Provide a the Log Analytics workspace name prefix"
      },
      "defaultValue": ""
    }
  }
PARAMETERS
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "field": "type",
      "equals": "Microsoft.RecoveryServices/vaults"
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "type": "Microsoft.Insights/diagnosticSettings",
        "name": "setByPolicy",
        "existenceCondition": {
          "allof": [
            {
              "count": {
                "field": "Microsoft.Insights/diagnosticSettings/logs[*]",
                "where": {
                  "allof": [
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs[*].Category",
                      "in": [
                        "CoreAzureBackup",
                        "AddonAzureBackupJobs",
                        "AddonAzureBackupAlerts",
                        "AddonAzureBackupPolicy",
                        "AddonAzureBackupStorage",
                        "AddonAzureBackupProtectedInstance"
                      ]
                    },
                    {
                      "field": "Microsoft.Insights/diagnosticSettings/logs[*].Enabled",
                      "equals": "True"
                    }
                  ]
                }
              },
              "Equals": 6
            },
            {
              "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
              "notEquals": "[parameters('logAnalytics')]"
            },
            {
              "field": "Microsoft.Insights/diagnosticSettings/logAnalyticsDestinationType",
              "equals": "Dedicated"
            }
          ]
        },
        "roleDefinitionIds": [
          "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
        ],
        "deployment": {
          "properties": {
            "mode": "incremental",
            "template": {
              "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
              "contentVersion": "1.0.0.0",
              "parameters": {
                "resourceName": {
                  "type": "string"
                },
                "logAnalytics": {
                  "type": "string"
                },
                "prefix": {
                  "type": "string"
                },
                "location": {
                  "type": "string"
                }
              },
              "variables": {},
              "resources": [
                {
                  "type": "Microsoft.RecoveryServices/vaults/providers/diagnosticSettings",
                  "apiVersion": "2017-05-01-preview",
                  "name": "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/, parameters('prefix'), 'setByPolicy')]",
                  "dependsOn": [],
                  "properties": {
                    "workspaceId": "[parameters('logAnalytics')]",
                    "logAnalyticsDestinationType": "Dedicated",
                    "metrics": [],
                    "logs": [
                      {
                        "category": "CoreAzureBackup",
                        "enabled": "true"
                      },
                      {
                        "category": "AddonAzureBackupAlerts",
                        "enabled": "true"
                      },
                      {
                        "category": "AddonAzureBackupJobs",
                        "enabled": "true"
                      },
                      {
                        "category": "AddonAzureBackupPolicy",
                        "enabled": "true"
                      },
                      {
                        "category": "AddonAzureBackupProtectedInstance",
                        "enabled": "true"
                      },
                      {
                        "category": "AddonAzureBackupStorage",
                        "enabled": "true"
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
              "prefix": {
                "value": "[parameters('prefix')]"
              },
              "location": {
                "value": "[field('location')]"
              },
              "resourceName": {
                "value": "[field('name')]"
              }
            }
          }
        }
      }
    }
  }
POLICY_RULE
}
/*
resource "azurerm_policy_assignment" "Deploy-Diagnostics-Recovery_Vault" {
  # count                = var.deployOptionalFeatures.deny_publicips_on_nics ? 1 : 0
  name                 = "Deploy-Diagnostics-Recovery_Vault"
  location             = var.log_analytics_workspace.location
  scope                = data.azurerm_subscription.primary.id
  policy_definition_id = azurerm_policy_definition.Deploy-Diagnostics-Recovery_Vault.id
  display_name         = "Deploy-Diagnostics-Recovery_Vault"
  description          = "Apply diagnostic settings for Azure Automation Accounts - Log Analytics"
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

resource "azurerm_policy_remediation" "Deploy-Diagnostics-Recovery_Vault" {
  name                 = lower("Deploy-Diagnostics-Recovery_Vault-policy-remediation")
  scope                = azurerm_policy_assignment.Deploy-Diagnostics-Recovery_Vault.scope
  policy_assignment_id = azurerm_policy_assignment.Deploy-Diagnostics-Recovery_Vault.id
  # location_filters     = ["West Europe"]
}
*/