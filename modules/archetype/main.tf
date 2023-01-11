resource "azurerm_management_group" "this" {
  name                       = var.management_group_name
  display_name               = coalesce(var.management_group_display_name, var.management_group_name)
  parent_management_group_id = var.management_group_parent_id
}

resource "azurerm_policy_definition" "this" {
  for_each = var.policy_definitions

  name                = each.key
  policy_type         = "Custom"
  mode                = each.value.mode
  display_name        = each.value.display_name
  description         = each.value.description
  management_group_id = azurerm_management_group.this.id
  policy_rule         = each.value.policy_rule
  metadata            = each.value.metadata
  parameters          = each.value.parameters
}

resource "azurerm_policy_set_definition" "this" {
  for_each = var.policy_set_definitions

  name         = each.key
  policy_type  = "Custom"
  display_name = each.value.display_name

  parameters = each.value.parameters
  metadata   = each.value.metadata

  dynamic "policy_definition_reference" {
    for_each = each.value.policy_definition_references
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      reference_id         = policy_definition_reference.value.policy_definition_reference_id
      parameter_values     = policy_definition_reference.value.parameters
    }
  }

  depends_on = [
    azurerm_policy_definition.this
  ]
}

resource "azurerm_management_group_policy_assignment" "this" {
  for_each = var.policy_assignments

  name                 = each.key
  management_group_id  = azurerm_management_group.this.id
  policy_definition_id = each.value.policy_definition_id
  display_name         = each.value.display_name
  description          = each.value.description
  parameters           = each.value.parameters

  dynamic "identity" {
    for_each = each.value.identity_type != null ? [0] : []
    content {
      type         = each.value.identity_type
      identity_ids = [each.value.identity_resource_id]
    }
  }

  depends_on = [
    azurerm_policy_definition.this,
    azurerm_policy_set_definition.this
  ]
}

resource "azurerm_role_definition" "this" {
  for_each = var.role_definitions

  name               = each.key
  role_definition_id = uuidv5("url", each.key)
  description        = each.value.description
  scope              = azurerm_management_group.this.id
  permissions {
    actions          = each.value.actions
    not_actions      = each.value.not_actions
    data_actions     = each.value.data_actions
    not_data_actions = each.value.not_data_actions
  }
}

resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignment_map

  scope                = azurerm_management_group.this.id
  role_definition_name = each.value.role_definition_management_group_id == "" ? each.value.role_definition_name : null
  role_definition_id   = each.value.role_definition_management_group_id != "" ? "/providers/Microsoft.Management/managementGroups/${each.value.role_definition_management_group_id}/providers/Microsoft.Authorization/roleDefinitions/${each.value.role_definition_id}" : null
  principal_id         = each.value.principal_id
  depends_on = [
    azurerm_role_definition.this
  ]
}
