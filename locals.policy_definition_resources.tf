# Read library Policy Definitions and rationalize by comparing with the definitions referenced
# in the resultant archetypes.
locals {
  policy_definitions_in_archetypes_list = distinct(flatten([[
    for k, v in local.resultant_archetypes : v.policy_definitions
    ]]
  ))

  custom_policy_definitions_file_list = length(local.policy_definitions_in_archetypes_list) > 0 ? tolist(fileset(local.module_library_path, "**/policy_definition_*.json")) : []

  custom_policy_definitions_data = [
    for f in local.custom_policy_definitions_file_list : jsondecode(file("${local.module_library_path}/${f}"))
  ]

  resultant_policy_definitions_map = {
    for d in local.custom_policy_definitions_data : d.name => {
      mode         = d.properties.mode
      display_name = d.properties.displayName
      description  = d.properties.description
      policy_rule  = jsonencode(d.properties.policyRule)
      metadata     = jsonencode(d.properties.metadata)
      parameters   = jsonencode(d.properties.parameters)
      assign_permissions_scopes = [
        for k, v in try(d.properties.parameters, {}) : k if try(v.metadata.assignPermissions, false) == true
      ]
      role_definition_ids = try(d.properties.policyRule.then.details.roleDefinitionIds, [])
    } if contains(local.policy_definitions_in_archetypes_list, d.name)
  }

  # This map is used to look up the management group id for a given policy definition
  # If a policy definition is in multiple archetypes, the first one found is used
  policy_definitions_to_management_group = {
    for i in flatten([
      for k, v in local.resultant_archetypes : [
        for pd in v.policy_definitions : {
          policy_definition_name = pd
          archetype_name         = k
        }
      ] if length(v.policy_definitions) > 0
    ]) : i.policy_definition_name => local.archetype_name_to_deployed_archetype[i.archetype_name][0]
  }

  # This map is used to lookup the policy definion name and provide the Azure resource id.
  policy_definition_name_to_resource_id = {
    for k, v in local.policy_definitions_to_management_group : k => "/providers/Microsoft.Management/managementGroups/${v}/providers/Microsoft.Authorization/policyDefinitions/${k}"
  }
}
