# Deploy Diagnostics Policies and PolicySet

Reference the module to a specific version (recommended):
```hcl
module Project-Diagnostic-Policy {
  source                  = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-diagnostic_policy_set?ref=v1.0.0"
  env                     = var.env
  userDefinedString       = local.prefix
  log_analytics_workspace = local.Project-law
  policy_name_postfix     " "somethingoptional"
}

```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| azurerm | >= 2.34.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.34.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | You can use a prefix to add to the list of resource groups you want to create | `string` | n/a | yes |
| log\_analytics\_workspace | Log analytics workspace object | `any` | n/a | yes |
| userDefinedString | UserDefinedString part of the name of the resource | `string` | n/a | yes |
| management\_group\_name | The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created. | `string` | `null` | no |
| policy\_name\_postfix | The postfix value to append at the end of the generated resource name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| object | Returns the policy\_set\_definition object created |
| policy\_set\_definition | Returns the policy\_set\_definition object created |

