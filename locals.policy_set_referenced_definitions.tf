# This logic gets all the policy definitions referenced by policy sets.
# Ultimately the goal is to generate a list of policy assignments.
#
# There are three possible scenarios:
# 1. The policy set is a custom policy set and the policy definitions are custom policy definitions.
# 2. The policy set is a custom policy set and the policy definitions are builtin policy definitions.
# 3. The policy set is a builtin policy set and the policy definitions are builtin policy definitions.

# Scenario 1
# - get the list of assigned, custom policy set names in local.resultant_policy_set_builtin_definitions
# - use this list to lookup the custom policy set in local.resultant_policy_set_definitions_map and nested loop through the policy definitions if they are custom
# - Extract the policy definition name and store in local.resultant_policy_set_custom_definitions.
#
# Scenario 2
# - get the list of assigned, custom policy set names from in resultant_policy_set_builtin_definitions
# - use this list to lookup the custom policy set in local.resultant_policy_set_definitions_map and nested loop through the policy definitions if they are builtin.
# - Extract the policy definition name in local.resultant_policy_set_builtin_definitions
# - use this list in the concat for local.combined_distinct_assigned_builtin_policy_definition_names
# - use this list in the for_each for data.azurerm_policy_definition.builtin to get the policy definitions from Azure
#
# Scenario 3
# - get the list of assigned, builtin policy set names in resultant_distinct_builtin_policy_set_names
# - use this list to create a map and a for_each loop to get the policy set definitions from Azure in data.azurerm_policy_set_definition.builtin
# - perform a nested for loop in the definitions, and again on policy_definition_references - store the policy_definition_id name in local.policy_definition_names_referenced_by_builtin_policy_sets
# - use this list in the concat for local.combined_distinct_assigned_builtin_policy_definition_names
# - use this list in the for_each for data.azurerm_policy_definition.builtin to get the policy definitions from Azure
#
# Once we have the data loaded for the custom and builtin policy definitions, we can retrieve the role definitions and any parameters with assignPermissions metadata tagged.
# - local.combined_policy_definition_additional_scopes is used to get additional scopes for both custom and builtin policy definitions.
# - local.combined_policy_definition_role_definitions is used to get the role definition ids for both custom and builtin policy definitions.
#
# Now we need to create a map of policy set definition names and the parameters that are mapped to definitions with assignPermissions metadata set to true.
# - local.combined_policy_set_additional_scopes is used to get additional scopes for both custom and builtin policy sets.
#
# Now we need to create a map of policy set definition names and the role definition ids for referenced policies.
# - local.combined_policy_set_role_definition_ids is used to get the role definition ids for both custom and builtin policy sets.
#


# These locals are required to build the data structure to support the role assignments
# and support for the assignPermissions parameter metadata.
locals {
  # These are all the builtin policy definition names that are directly assigned by the policy assignments.
  resultant_distinct_builtin_policy_definition_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if v.definition_is_builtin && !v.definition_is_policy_set
  ])

  # These are all the custom policy definition names that are directly assigned by the policy assignments.
  resultant_distinct_custom_policy_definition_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if !v.definition_is_builtin && !v.definition_is_policy_set
  ])

  # These are all the builtin policy set definition names that are directly assigned by the policy assignments.
  resultant_distinct_builtin_policy_set_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if v.set_definition_is_builtin && v.definition_is_policy_set
  ])

  # These are all the custom policy set definition names that are directly assigned by the policy assignments.
  resultant_distinct_custom_policy_set_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if !v.set_definition_is_builtin && v.definition_is_policy_set
  ])
}

locals {
  # This list performs a for loop on the custom policy sets that are assigned.
  # Then looks up the referenced custom policy definition name.
  # The result is a list of custom policy definition names referenced by custom policy sets that are assigned.
  # See scenario 1 above.
  resultant_policy_set_custom_definitions = distinct(flatten([
    for i in local.resultant_distinct_custom_policy_set_names : [
      for d in local.resultant_policy_set_definitions_map[i].policy_definition_references : reverse(split("/", d.policy_definition_id))[0] if !d.definition_is_builtin
    ]
  ]))
}

locals {
  # This list performs a for loop on the custom policy sets that are assigned.
  # Then looks up the referenced builtin policy definitions.
  # The result is a list of builtin policy definition names referenced by custom policy sets that are assigned.
  # See scenario 2 above.
  resultant_policy_set_builtin_definitions = distinct(flatten([
    for i in local.resultant_distinct_custom_policy_set_names : [
      for d in local.resultant_policy_set_definitions_map[i].policy_definition_references : reverse(split("/", d.policy_definition_id))[0] if d.definition_is_builtin
    ]
  ]))
}

locals {
  # This list performs a for loop on the assigned builtin policy sets that are retrieved from Azure
  # and creates a list of all the referenced (builtin) policy definition names (these are GUIDs).
  # See scenario 3 above.
  policy_definition_names_referenced_by_builtin_policy_sets = distinct(flatten([
    for k, v in data.azurerm_policy_set_definition.builtin : [
      for r in v.policy_definition_reference : reverse(split("/", r.policy_definition_id))[0]
    ]
  ]))
}

locals {
  # This is a list of builtin policy definitions referenced assignments, or assigned policy sets.
  # This is fed into the data.azurerm_policy_definition.builtin for_each loop.
  combined_distinct_assigned_builtin_policy_definition_names = distinct(flatten([
  [
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if v.definition_is_builtin && !v.definition_is_policy_set
  ],
    local.resultant_policy_set_builtin_definitions,
    local.policy_definition_names_referenced_by_builtin_policy_sets
  ]))
}


# Locals pertaining to the assignPermissions parameter metadata.
locals {
  # This is a map of builtin policy definition names with any parameter names that have assignPermissions metadata set to true.
  # This is combined into a combined map containing data from custom policy defs as well.
  builtin_policy_definition_additional_scopes = {
    for k, v in data.azurerm_policy_definition.builtin : k => flatten([
      for k2, v2 in try(jsondecode(v.parameters), {}) : [
        k2
        ] if try(v2.metadata.assignPermissions, false) == true
    ])
  }

  custom_policy_definition_additional_scopes = {
    for i in local.resultant_policy_set_custom_definitions : i => flatten(local.resultant_policy_definitions_map[i].assign_permissions_scopes)
  }

  # This is a map of all policy definition names with any parameter names that have assignPermissions metadata set to true.
  combined_policy_definition_additional_scopes = merge(
    local.builtin_policy_definition_additional_scopes,
    local.custom_policy_definition_additional_scopes
  )
}

# Locals pertaining to the role definitions for assigned policies
locals {
  # for each of the builtin policy definitions, read the policy+rule attribute and return a list of the then.details.roleDefinitionIds
  policy_definintion_builtin_role_definition_ids = {
    for k, v in data.azurerm_policy_definition.builtin : k => try(jsondecode(v.policy_rule).then.details.roleDefinitionIds, [])
  }
  policy_definition_custom_role_definition_ids = {
    for i in local.resultant_policy_set_custom_definitions : i => local.resultant_policy_definitions_map[i].role_definition_ids
  }
  combined_policy_definition_role_definition_ids = merge(
    local.policy_definintion_builtin_role_definition_ids,
    local.policy_definition_custom_role_definition_ids
  )
}

# Locals pertaining to the policy set parameters that map to definition parameters with assignPermissions set.
locals {
  builtin_policy_set_additional_scopes = {
    # Loop over all the assigned builtin policy sets, creating a map using the policy name (a guid as it's built in) as the key
    # producing a list of parameter names as the value.
    for k, v in data.azurerm_policy_set_definition.builtin : k => distinct(flatten([
      # Loop over the policy set's policy definition references
      [ for r in v.policy_definition_reference :
        [
          # Loop over the referenced policy definition's parameters - decoded from JSON due to the data source not populating the `parameters` attribute
          for k2, v2 in try(jsondecode(r.parameter_values), {}) :
            # This regex extracts the parameter name from the parameter value expression, e.g. [parameters('logAnalytics')] would return logAnalytics.
            # This would be an item in the list value of the resultant map.
            # There is a condition to ensure that the parameter name is in the list of parameter names that have assignPermissions set to true,
            # this is achieved by looking up the policy definition name in the local.combined_policy_definition_additional_scopes map.
            try(regex("\\[parameters\\('(.*)'\\)\\]", tostring(v2.value))[0], "") if contains(
              lookup(
                local.combined_policy_definition_additional_scopes,
                reverse(
                  split("/", r.policy_definition_id)
                )[0],
                []
              ),
              k2
            )
        ]
      ]
    ]))
  }

  custom_policy_set_additional_scopes = {
    # Loop over all the assigned custom policy sets, creating a map using the policy name as the key
    # producing a list of parameter names as the value.
    for i in local.resultant_distinct_custom_policy_set_names : i => distinct(flatten([
      # Look up the policy definition references for the policy set in the local.resultant_policy_set_definitions_map and loop over them.
      for r in local.resultant_policy_set_definitions_map[i].policy_definition_references : [
        # This regex extracts the parameter name from the parameter value expression, e.g. [parameters('logAnalytics')] would return logAnalytics.
        # This would be an item in the list value of the resultant map.
        # There is a condition to ensure that the parameter name is in the list of parameter names that have assignPermissions set to true,
        # this is achieved by looking up the policy definition name in the local.combined_policy_definition_additional_scopes map.
        for k, v in try(jsondecode(r.parameters), {}) : try(regex("\\[parameters\\('(.*)'\\)\\]", tostring(v.value))[0], "") if contains(
          lookup(
            local.combined_policy_definition_additional_scopes,
            reverse(
              split("/", r.policy_definition_id)
            )[0],
            []
          ),
          k
          )
      ]
    ]))
  }

  # Merge the two previous maps into a single map.
  combined_policy_set_additional_scopes = merge(
    local.builtin_policy_set_additional_scopes,
    local.custom_policy_set_additional_scopes
  )
}

# Locals pertaining to the policy set resource definition ids that are assigned by referenced policy definitions.
locals {
  # This is a map of builtin policy set names with any role definition ids that are assigned by referenced policy definitions.
  builtin_policy_set_role_definition_ids = {
    for k, v in data.azurerm_policy_set_definition.builtin : k => distinct(flatten([
      [
        for r in v.policy_definition_reference : lookup(local.combined_policy_definition_role_definition_ids, reverse(split("/", r.policy_definition_id))[0], [])
      ]
    ]))
  }

  # This is a map of custom policy set names with any role definition ids that are assigned by referenced policy definitions.
  custom_policy_set_role_definition_ids = {
    for i in local.resultant_distinct_custom_policy_set_names : i => distinct(flatten([
      [
        for r in local.resultant_policy_set_definitions_map[i].policy_definition_references : lookup(local.combined_policy_definition_role_definition_ids, reverse(split("/", r.policy_definition_id))[0], [])
      ]
    ]))
  }

  # Merge the two previous maps into a single map.`
  combined_policy_set_role_definition_ids = merge(
    local.builtin_policy_set_role_definition_ids,
    local.custom_policy_set_role_definition_ids
  )
}

locals {
  resultant_policy_assignments_role_assignment_data_keys = {
    policy_definition_keys = distinct(flatten([
      keys(local.combined_policy_set_role_definition_ids),
      keys(local.combined_policy_set_additional_scopes),
    ]))
    policy_set_definition_keys = distinct(flatten([
      keys(local.combined_policy_set_role_definition_ids),
      keys(local.combined_policy_definition_additional_scopes),
    ]))
  }
  resultant_policy_assignments_role_assignment_data = {
    policy_definition_data = {
      for i in local.resultant_policy_assignments_role_assignment_data_keys.policy_definition_keys : i => {
        role_definition_ids = lookup(local.combined_policy_definition_role_definition_ids, i, [])
        additional_scopes   = lookup(local.combined_policy_definition_additional_scopes, i, [])
      }}
      policy_set_definition_data = {
      for i in local.resultant_policy_assignments_role_assignment_data_keys.policy_set_definition_keys : i => {
        role_definition_ids = lookup(local.combined_policy_set_role_definition_ids, i, [])
        additional_scopes   = lookup(local.combined_policy_set_additional_scopes, i, [])
    }}
  }
}
