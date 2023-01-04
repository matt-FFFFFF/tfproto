resource "azurerm_management_group" "this" {
  name                       = var.management_group_name
  display_name               = coalesce(var.management_group_display_name, var.management_group_name)
  parent_management_group_id = var.management_group_parent_id
}

resource "azurerm_policy_definition" "this" {
  for_each = var.policy_definitions

  name                = each.value.name
  policy_type         = "Custom"
  mode                = each.value.mode
  display_name        = each.value.display_name
  description         = each.value.description
  management_group_id = azurerm_management_group.this.id
  policy_rule         = each.value.policy_rule
  metadata            = each.value.metadata
  parameters          = each.value.parameters
}
