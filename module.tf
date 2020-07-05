data azurerm_subscription primary {}

locals {
  policy_set_name = substr("${var.env}-${var.userDefinedString} diagnostic policy set", 0, 64)
  /*
  policies = {
    AA = {
      name        = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure Automation Accounts - Log Analytics"
    },
    ACI = {
      name        = "Deploy-Diagnostics-ACI"
      description = "Apply diagnostic settings for Azure Container Instances - Log Analytics"
    },
    ACR = {
      name        = "Deploy-Diagnostics-ACR"
      description = "Apply diagnostic settings for Azure Container Registries - Log Analytics"
    },
    ActivityLog = {
      name        = "Deploy-Diagnostics-ActivityLog"
      description = "Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics"
    },
    AKS = {
      name        = "Deploy-Diagnostics-AKS"
      description = "Apply diagnostic settings for Azure Kubernetes Service - Log Analytics"
    },
    AnalysisServices = {
      name        = "Deploy-Diagnostics-AnalysisServices"
      description = "Apply diagnostic settings for Azure Analysis Services - Log Analytics"
    },
    APIMgmt = {
      name        = "Deploy-Diagnostics-APIMgmt"
      description = "Apply diagnostic settings for API Management services - Log Analytics"
    },
    ApplicationGateway = {
      name        = "Deploy-Diagnostics-ApplicationGateway"
      description = "Apply diagnostic settings for Application Gateway services - Log Analytics"
    },
    Batch = {
      name        = "Deploy-Diagnostics-Batch"
      description = "Apply diagnostic settings for Azure Batch accounts - Log Analytics"
    },
    KeyVault = {
      name        = "Deploy-Diagnostics-KeyVault"
      description = "Apply diagnostic settings for Azure KeyVault - Log Analytics"
    },
    NIC = {
      name        = "Deploy-Diagnostics-NIC"
      description = "Apply diagnostic settings for Azure NIC - Log Analytics"
    },
    NSG = {
      name        = "Deploy-Diagnostics-NSG"
      description = "Apply diagnostic settings for Azure NSG - Log Analytics"
    },
    Recovery_Vault = {
      name        = "Deploy-Diagnostics-Recovery_Vault"
      description = "Apply diagnostic settings for Azure Recovery Vault - Log Analytics"
    },
    VM = {
      name        = "Deploy-Diagnostics-VM"
      description = "Apply diagnostic settings for Azure VM - Log Analytics"
    },
    VMSS = {
      name        = "Deploy-Diagnostics-VMSS"
      description = "Apply diagnostic settings for Azure VM Scale Set - Log Analytics"
    },
    VNET = {
      name        = "Deploy-Diagnostics-VNET"
      description = "Apply diagnostic settings for Azure VNET - Log Analytics"
    }
  }
  */
  subscriptionID = data.azurerm_subscription.primary.subscription_id
  policies_json  = jsondecode(templatefile("${path.module}/policies/all-policies.json", { subscriptionID = local.subscriptionID }))
  policies = {
    for item in local.policies_json.parameters.input.value.properties.policyDefinitions :
    item.Name => {
      name        = item.Name
      description = try(item.Properties.description, "")
      policyRule  = item.Properties.policyRule
    }
  }
  policy_assignment = local.policies_json.parameters.input.value.properties.policySetDefinitions[1].Properties.policyDefinitions
}

resource "azurerm_policy_definition" "policy_definition" {
  for_each = local.policies

  name         = each.value.name
  policy_type  = "Custom"
  mode         = "All"
  display_name = each.value.name
  description  = each.value.description
  parameters   = file("${path.module}/policies/Deploy-Diagnostics-parameters.json")
  # policy_rule  = file("${path.module}/policies/${each.value.name}.json")
  policy_rule = each.value.policyRule
}

resource "azurerm_policy_set_definition" "policy_set_definition" {
  depends_on         = [azurerm_policy_definition.policy_definition]
  count              = var.deploy ? 1 : 0
  name               = local.policy_set_name
  policy_type        = "Custom"
  display_name       = local.policy_set_name
  description        = "This initiative configures application Azure resources to forward diagnostic logs and metrics to an Azure Log Analytics workspace."
  parameters         = file("${path.module}/policies/Deploy-Diagnostics-parameters.json")
  policy_definitions = jsonencode(local.policy_assignment)
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