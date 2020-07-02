# Apply Diagnostics Policies on a Subscription
Sets one or more resource groups, each of them in a specific Azure region.

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

| Name                    | Type   | Default | Description                                                                                                                          |
| ----------------------- | ------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| log_analytics_workspace | object | None    | (Required) The log analytics workspace object where to send the diagnostics logs. Changing this forces a new resource to be created. |
| env                     | string | None    | (Required) env name                                                                                                                  |
| userDefinedString       | string | None    | (Required) userDefinedString to be Used.                                                                                             |

## Parameters

## Outputs
| Name                  | Type   | Description                                    |
| --------------------- | ------ | ---------------------------------------------- |
| policy_set_definition | object | Returns the full policy_set_definition object. |
| policy_assignment     | object | Returns the full policy_assignment object      |
