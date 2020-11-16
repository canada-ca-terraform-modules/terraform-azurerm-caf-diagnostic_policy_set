module resource_groups {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-resource_groups?ref=v1.0.0"
  resource_groups = {
    test = {
      userDefinedString = "${local.userDefinedStringPrefix}_test"
    },
  }
  env      = local.env
  location = local.location
  tags     = local.tags
}

locals {
  resource_groups = module.resource_groups.object
}