# Apply Diagnostics Policies on a Subscription

Reference the module to a specific version (recommended):
```hcl
module Project-Diagnostic-Policy {
  source                  = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-diagnostic_policy_set?ref=v0.1.0"
  env                     = var.env
  userDefinedString       = local.prefix
  log_analytics_workspace = local.Project-law
}

```

## Inputs 

| Name                    | Type   | Default                | Description                                                                                                                                                                               |
| ----------------------- | ------ | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| log_analytics_workspace | object | None                   | (Required) The log analytics workspace object where to send the diagnostics logs. Changing this forces a new resource to be created.                                                      |
| env                     | string | None                   | (Required) env name                                                                                                                                                                       |
| userDefinedString       | string | None                   | (Required) userDefinedString to be Used.                                                                                                                                                  |
| scopeID                 | string | Current SubscriptionID | (Optional) Object ID of the scope to which the policy shoule be applied. Can be one of Management Group ID, Subscription ID or Resource Group ID. Default is the current Subscription ID. |
| deploy                  | bool   | true                   | (Optional) Should the module be deployed                                                                                                                                                  |

## Parameters

## Outputs
| Name                  | Type   | Description                                    |
| --------------------- | ------ | ---------------------------------------------- |
| policy_set_definition | object | Returns the full policy_set_definition object. |
| policy_assignment     | object | Returns the full policy_assignment object      |
