# Read library Policy Assignments and rationalize by comparing with the definitions referenced
# in the resultant archetypes.
locals {
  policy_assignments_in_archetypes_list = distinct(flatten([
    [
      for k, v in local.resultant_archetypes : v.policy_assignments
    ]
    ]
  ))

  custom_policy_assignments_file_list = length(local.policy_assignments_in_archetypes_list) > 0 ? tolist(fileset(local.module_library_path, "**/policy_assignment_*.json")) : []

  custom_policy_assignments_data = [
    for f in local.custom_policy_assignments_file_list : jsondecode(file("${local.module_library_path}/${f}"))
  ]

  resultant_policy_assignments_map = {
    for a in local.custom_policy_assignments_data : a.name => {
      display_name                      = a.properties.displayName
      description                       = a.properties.description
      metadata                          = try(jsonencode(a.properties.metadata), null)
      policy_definition_id              = lookup(local.resultant_policy_definitions_map, reverse(split("/", a.properties.policyDefinitionId))[0], null) != null ? local.policy_definition_name_to_resource_id[reverse(split("/", a.properties.policyDefinitionId))[0]] : a.properties.policyDefinitionId
      parameters                        = try(jsonencode(a.properties.parameters), null)
      definition_is_builtin             = lookup(local.resultant_policy_definitions_map, reverse(split("/", a.properties.policyDefinitionId))[0], null) == null ? true : false
      definition_is_policy_set          = lower(reverse(split("/", a.properties.policyDefinitionId))[1]) == "policysetdefinitions" ? true : false
      set_definition_is_builtin         = lookup(local.resultant_policy_set_definitions_map, reverse(split("/", a.properties.policyDefinitionId))[0], null) == null ? true : false
      enforcement_mode                  = try(a.properties.enforcementMode, null)
      identity_type                     = try(a.properties.identity.type, null)
      identity_resource_id              = try(keys(a.properties.identity.userAssignedIdentities), null)
      role_assignment_definitions       = null
      role_assignment_additional_scopes = null
    } if contains(local.policy_assignments_in_archetypes_list, a.name)
  }

  resultant_distinct_builtin_policy_definition_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if v.definition_is_builtin && !v.definition_is_policy_set
  ])

  resultant_distinct_builtin_policy_set_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if v.set_definition_is_builtin && v.definition_is_policy_set
  ])

  resultant_distinct_custom_policy_set_names = distinct([
    for k, v in local.resultant_policy_assignments_map : reverse(split("/", v.policy_definition_id))[0] if !v.set_definition_is_builtin && v.definition_is_policy_set
  ])
}
