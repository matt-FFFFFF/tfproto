data "azurerm_policy_definition" "builtin" {
  for_each = { for i in local.resultant_distinct_builtin_policy_definition_names : i => null }
  name     = each.key
}

data "azurerm_policy_set_definition" "builtin" {
  for_each = { for i in local.resultant_distinct_builtin_policy_set_names : i => null }
  name     = each.key
}
