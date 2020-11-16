module "Project-law" {
  source            = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-log_analytics_workspace?ref=v1.0.2"
  userDefinedString = "${local.group}_${local.project}"
  resource_group    = local.resource_groups.test
  env               = local.env
  tags              = local.tags

  solution_plan_map = {
    ServiceMap = {
      publisher = "Microsoft"
      product   = "OMSGallery/ServiceMap"
    },
    AzureActivity = {
      publisher = "Microsoft"
      product   = "OMSGallery/AzureActivity"
    },
    AgentHealthAssessment = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/AgentHealthAssessment"
    },
    DnsAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/DnsAnalytics"
    },
    KeyVaultAnalytics = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/KeyVaultAnalytics"
    },
    Updates = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/Updates"
    },
    ChangeTracking = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/ChangeTracking"
    }
  }
}

locals {
  Project-law = module.Project-law.object
}