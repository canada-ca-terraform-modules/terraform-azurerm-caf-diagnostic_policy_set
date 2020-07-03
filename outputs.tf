output "policy_set_definition" {
  value = var.deploy ? azurerm_policy_set_definition.policy_set_definition : null
}

output "policy_assignment" {
  value = var.deploy ? azurerm_policy_assignment.policy_assignment : null
}