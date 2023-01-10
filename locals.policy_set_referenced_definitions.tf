# This logic gets all the policy definitions referenced by policy sets.
#
# There are three possible scenarios:
# 1. The policy set is a custom policy set and the policy definitions are custom policy definitions.
# 2. The policy set is a custom policy set and the policy definitions are builtin policy definitions.
# 3. The policy set is a builtin policy set and the policy definitions are builtin policy definitions.

# Scenario 1
#
# Scenario 2
#
# Scenario 3
# - get the list of assigned, builtin policy set names in resultant_distinct_builtin_policy_set_names
# - use this list to create a map and a for_each loop to get the policy set definitions from Azure in data.azurerm_policy_set_definition.builtin
# - perform a nested for loop in the definitions, and again on policy_definition_references - store the policy_definition_id name in local.policy_definition_names_referenced_by_builtin_policy_sets
# - use this list in the concat for local.combined_distinct_assigned_builtin_policy_definition_names
# - use this list in the for_each for data.azurerm_policy_definition.builtin to get the policy definitions from Azure


locals {
  # This is a list of builtin policy definitions referenced assignments, or assigned policy sets
  combined_distinct_assigned_builtin_policy_definition_names = distinct(flatten([
  [
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if v.definition_is_builtin && !v.definition_is_policy_set
  ],
    local.resultant_policy_set_builtin_definitions,
    local.policy_definition_names_referenced_by_builtin_policy_sets
  ]))

  resultant_distinct_assigned_custom_policy_set_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if !v.set_definition_is_builtin && v.definition_is_policy_set && contains(local.resultant_assigned_policy_set_names, k)
  ])

  # This is a list of builtin policy definitions referenced by policy sets that are assigned
  resultant_policy_set_builtin_definitions = distinct(flatten([
    for k, v in local.resultant_policy_set_definitions_map : [
      for d in v.policy_definition_references : d.policy_definition_id if d.definition_is_builtin
    ] if contains(local.resultant_assigned_policy_set_names, k)
  ]))

  policy_definition_names_referenced_by_builtin_policy_sets = distinct(flatten([
    for k, v in data.azurerm_policy_set_definition.builtin : [
      for r in v.policy_definition_reference : reverse(split("/", r.policy_definition_id))[0]
    ]
  ]))

  builtin_policy_definition_additional_scopes = {
    for k, v in data.azurerm_policy_definition.builtin : k => [
      for k2, v2 in try(jsondecode(v.parameters), {}) : [
        k2
      ] if try(v2.metadata.assignPermissions, false) == true
    ]
  }
  builtin_policy_definition_additional_scopes_sanitized = {
    for k, v in local.builtin_policy_definition_additional_scopes : k => v if length(v) > 0
  }
}
