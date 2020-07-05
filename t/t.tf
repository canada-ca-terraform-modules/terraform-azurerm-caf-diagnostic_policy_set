locals {
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
  policySet = [
    for item in local.policies :
    
      key
    
  ]
}

output res {
    value = local.policySet
}