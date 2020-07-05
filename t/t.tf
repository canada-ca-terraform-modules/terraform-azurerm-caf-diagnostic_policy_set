locals {
  test = jsondecode(templatefile("../policies/all-policies.json", { subscriptionID = "3453 sdfsdf"}))
  policies = {
    AA = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure Automation Accounts - Log Analytics"
    },
    ActivityLog = {
      name = "Deploy-Diagnostics-AA"
      description = "Ensures that Activity Log Diagnostics settings are set to push logs into Log Analytics"
    },
    KeyVault = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure KeyVault - Log Analytics"
    },
    NIC = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure NIC - Log Analytics"
    },
    NSG = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure NSG - Log Analytics"
    },
    Recovery_Vault = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure Recovery Vault - Log Analytics"
    },
    VM = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure VM - Log Analytics"
    },
    VMSS = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure VM Scale Set - Log Analytics"
    },
    VNET = {
      name = "Deploy-Diagnostics-AA"
      description = "Apply diagnostic settings for Azure VNET - Log Analytics"
    }
  }
  subscriptionID = "54353534 4543"
  policySet = {
    for item in local.test.parameters.input.value.properties.policyDefinitions :
    item.Name => {
      name = item.Name
      description = try(item.Properties.description, "")
      #policyRule = item.Properties.policyRule
    }
  }
  policy_assignment = local.test.parameters.input.value.properties.policySetDefinitions[1].Properties.policyDefinitions
}

output res {
    value = local.policySet
}