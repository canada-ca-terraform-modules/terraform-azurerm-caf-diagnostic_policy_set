output "policy_set_definition" {
  value = var.deploy ? azurerm_policy_set_definition.policy_set_definition[0] : null
}

output "id" {
  value = var.deploy ? azurerm_policy_set_definition.policy_set_definition[0].id : null
}
