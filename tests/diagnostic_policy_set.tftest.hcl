# tests/diagnostic_policy_set.tftest.hcl
#
# Functional coverage for the module's two resources (azurerm_policy_definition,
# azurerm_policy_set_definition). mock_provider intercepts all API calls — no
# Azure credentials needed. Run: terraform init -backend=false && terraform test

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

# --- default_values -------------------------------------------------------
# Minimal required inputs, no management_group_id, no postfix, no name override.
run "default_values" {
  command = plan

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.policy_type == "Custom"
    error_message = "policy_set_definition.policy_type must be Custom"
  }

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.name == "Dev-test diagnostic initiative"
    error_message = "Subscription-scope name must follow '{env}-{userDefinedString} diagnostic initiative'"
  }

  assert {
    condition     = azurerm_policy_definition.policy_definition["Deploy-Diagnostics-AA"].name == "Deploy-Diagnostics-AA"
    error_message = "Policy definition name must match the catalog Name with no postfix applied"
  }

  assert {
    condition     = azurerm_policy_definition.policy_definition["Deploy-Diagnostics-AA"].management_group_id == null
    error_message = "management_group_id must be null at subscription scope"
  }
}

# --- policy_name_postfix ---------------------------------------------------
run "policy_name_postfix" {
  command = plan
  variables {
    policy_name_postfix = "-postfix"
  }

  assert {
    condition     = azurerm_policy_definition.policy_definition["Deploy-Diagnostics-AA"].name == "Deploy-Diagnostics-AA-postfix"
    error_message = "policy_name_postfix must be appended to every policy definition name"
  }

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.name == "Dev-test diagnostic initiative-postfix"
    error_message = "policy_name_postfix must be appended to the policy set definition name"
  }
}

# --- management_group scope --------------------------------------------------
run "management_group_scope" {
  command = plan
  variables {
    management_group_id = "mg-test"
  }

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.name == "Deploy-Diagnostic-Initiative"
    error_message = "Management-group-scope name must be the fixed 'Deploy-Diagnostic-Initiative' string"
  }

  assert {
    condition     = azurerm_policy_definition.policy_definition["Deploy-Diagnostics-AA"].management_group_id == "mg-test"
    error_message = "management_group_id must be passed through to azurerm_policy_definition"
  }
}

# --- custom_policy_set_name (Pattern 12 override) ---------------------------
run "custom_policy_set_name" {
  command = plan
  variables {
    policy_set_definition_name = "existing-prod-initiative"
  }

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.name == "existing-prod-initiative"
    error_message = "policy_set_definition_name override must take priority over the generated name"
  }

  assert {
    condition     = azurerm_policy_set_definition.policy_set_definition.display_name == "existing-prod-initiative"
    error_message = "policy_set_definition_name override must also apply to display_name"
  }
}
