# Read library Policy Definitions and rationalize by comparing with the definitions referenced
# in the resultant archetypes.
locals {
  policy_set_definitions_in_archetypes_list = distinct(flatten([
    [
      for k, v in local.resultant_archetypes : v.policy_set_definitions
    ]
    ]
  ))

  custom_policy_set_definitions_file_list = length(local.policy_set_definitions_in_archetypes_list) > 0 ? tolist(fileset(local.module_library_path, "**/policy_set_definition_*.json")) : []

  custom_policy_set_definitions_data = [
    for f in local.custom_policy_set_definitions_file_list : jsondecode(file("${local.module_library_path}/${f}"))
  ]

  resultant_policy_set_definitions_map = {
    for d in local.custom_policy_set_definitions_data : d.name => {
      display_name = d.properties.displayName
      description  = try(d.properties.description, "")
      metadata     = try(jsonencode(d.properties.metadata), null)
      parameters   = try(jsonencode(d.properties.parameters), null)
      policy_definition_references = [
        for i in d.properties.policyDefinitions : {
          # This unweildy expression is to handle the case where the policy definition is custom and we have to look up the management group to construct the resource id
          # We take the last segment of the supplied definition id and look it up in the policy_definitions_to_archetype map
          # If it is found, we construct the resource id using the deployed archetype name from the map
          policy_definition_id           = lookup(local.resultant_policy_definitions_map, reverse(split("/",i.policyDefinitionId))[0], null) != null ? "/providers/Microsoft.Management/managementGroups/${local.policy_definitions_to_management_group[reverse(split("/",i.policyDefinitionId))[0]]}/providers/Microsoft.Authorization/policyDefinitions/${reverse(split("/",i.policyDefinitionId))[0]}" : i.policyDefinitionId
          parameters                     = try(jsonencode(i.parameters), null)
          policy_definition_reference_id = try(i.policyDefinitionReferenceId, null)
        }
      ]
    } if contains(local.policy_set_definitions_in_archetypes_list, d.name)
  }
}
