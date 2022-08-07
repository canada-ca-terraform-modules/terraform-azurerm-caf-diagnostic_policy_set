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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.34.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.34.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_definition.policy_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_set_definition.policy_set_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition) | resource |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | You can use a prefix to add to the list of resource groups you want to create | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Log analytics workspace object | `any` | n/a | yes |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_policy_name_postfix"></a> [policy\_name\_postfix](#input\_policy\_name\_postfix) | The postfix value to append at the end of the generated resource name | `string` | `""` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | UserDefinedString part of the name of the resource | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_object"></a> [object](#output\_object) | Returns the policy\_set\_definition object created |
| <a name="output_policy_set_definition"></a> [policy\_set\_definition](#output\_policy\_set\_definition) | Returns the policy\_set\_definition object created |
