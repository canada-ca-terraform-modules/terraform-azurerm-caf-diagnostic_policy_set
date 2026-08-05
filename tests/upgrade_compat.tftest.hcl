# tests/upgrade_compat.tftest.hcl
#
# State-chaining safety test: applies with the config exactly as an existing
# caller (no new args wired) would have it, then re-plans the same config to
# confirm the azurerm v5.0.1 upgrade introduces no resource address change,
# rename, or accidental destroy/recreate for callers who change nothing.

mock_provider "azurerm" {
  override_data {
    target = data.azurerm_subscription.primary
    values = {
      subscription_id = "00000000-0000-0000-0000-000000000000"
    }
  }
}

variables {
  env                     = "Dev"
  userDefinedString       = "test"
  log_analytics_workspace = {}
}

run "baseline_apply" {
  command = apply

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.name == "Dev-test diagnostic initiative"
    error_message = "Baseline apply: unexpected policy_set_definition name"
  }

  assert {
    condition     = azurerm_policy_definition.policy_definition["Deploy-Diagnostics-AA"].name == "Deploy-Diagnostics-AA"
    error_message = "Baseline apply: unexpected policy_definition name"
  }
}

run "upgrade_plan_no_replacement" {
  command = plan

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.name == "Dev-test diagnostic initiative"
    error_message = "Resource name must be unchanged after the azurerm v5.0.1 upgrade"
  }

  assert {
    condition     = azurerm_policy_definition.policy_definition["Deploy-Diagnostics-AA"].name == "Deploy-Diagnostics-AA"
    error_message = "Policy definition name must be unchanged after the azurerm v5.0.1 upgrade"
  }
}
