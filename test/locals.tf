locals {
  location                = "canadacentral"
  env                     = "ScTC"
  group                   = "test"
  project                 = "diagnostic_policy"
  unique_Logs             = substr(sha1(local.resource_groups.test.id), 0, 8)
  userDefinedStringPrefix = "${local.group}_${local.project}"
  prefix                  = "${local.env}-${local.userDefinedStringPrefix}"
  l0_prefix               = "${local.env}-${local.group}_${local.project}"
  tags = {
    "test" = "test"
  }
}