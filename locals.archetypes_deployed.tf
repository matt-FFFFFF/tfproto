locals {
  # These locals represent the archetypes that are deployed to the tenant.
  # They are organized into 'levels' according to the parent_id of the archetype.
  # They contain the data that is required to deploy the archetype, with Azure resource data read from the library.

  archetypes_deployed_level_1 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments = local.resultant_archetypes[v.archetype].policy_assignments
      policy_definitions = {
        for pd in local.resultant_archetypes[v.archetype].policy_definitions : pd => {
          name         = local.resultant_policy_definitions_map[pd].name
          mode         = local.resultant_policy_definitions_map[pd].properties.mode
          display_name = local.resultant_policy_definitions_map[pd].properties.displayName
          description  = local.resultant_policy_definitions_map[pd].properties.description
          policy_rule  = jsonencode(local.resultant_policy_definitions_map[pd].properties.policyRule)
          metadata     = jsonencode(local.resultant_policy_definitions_map[pd].properties.metadata)
          parameters   = jsonencode(local.resultant_policy_definitions_map[pd].properties.parameters)
        }
      }
      policy_set_definitions = local.resultant_archetypes[v.archetype].policy_set_definitions
      role_assignments       = local.resultant_archetypes[v.archetype].role_assignments
      role_definitions       = local.resultant_archetypes[v.archetype].role_definitions
      parent_id              = coalesce(var.root_parent_id, data.azurerm_client_config.current.tenant_id)
      display_name           = v.display_name
    } if v.parent_id == ""
  }

  archetypes_deployed_level_2 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments     = local.resultant_archetypes[v.archetype].policy_assignments
      policy_definitions     = local.resultant_archetypes[v.archetype].policy_definitions
      policy_set_definitions = local.resultant_archetypes[v.archetype].policy_set_definitions
      role_assignments       = local.resultant_archetypes[v.archetype].role_assignments
      role_definitions       = local.resultant_archetypes[v.archetype].role_definitions
      parent_id              = v.parent_id
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_1), v.parent_id)
  }

  archetypes_deployed_level_3 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments     = local.resultant_archetypes[v.archetype].policy_assignments
      policy_definitions     = local.resultant_archetypes[v.archetype].policy_definitions
      policy_set_definitions = local.resultant_archetypes[v.archetype].policy_set_definitions
      role_assignments       = local.resultant_archetypes[v.archetype].role_assignments
      role_definitions       = local.resultant_archetypes[v.archetype].role_definitions
      parent_id              = v.parent_id
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_2), v.parent_id)
  }

  archetypes_deployed_level_4 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments     = local.resultant_archetypes[v.archetype].policy_assignments
      policy_definitions     = local.resultant_archetypes[v.archetype].policy_definitions
      policy_set_definitions = local.resultant_archetypes[v.archetype].policy_set_definitions
      role_assignments       = local.resultant_archetypes[v.archetype].role_assignments
      role_definitions       = local.resultant_archetypes[v.archetype].role_definitions
      parent_id              = v.parent_id
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_3), v.parent_id)
  }

  archetypes_deployed_level_5 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments     = local.resultant_archetypes[v.archetype].policy_assignments
      policy_definitions     = local.resultant_archetypes[v.archetype].policy_definitions
      policy_set_definitions = local.resultant_archetypes[v.archetype].policy_set_definitions
      role_assignments       = local.resultant_archetypes[v.archetype].role_assignments
      role_definitions       = local.resultant_archetypes[v.archetype].role_definitions
      parent_id              = v.parent_id
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_4), v.parent_id)
  }

  archetypes_deployed_level_6 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments     = local.resultant_archetypes[v.archetype].policy_assignments
      policy_definitions     = local.resultant_archetypes[v.archetype].policy_definitions
      policy_set_definitions = local.resultant_archetypes[v.archetype].policy_set_definitions
      role_assignments       = local.resultant_archetypes[v.archetype].role_assignments
      role_definitions       = local.resultant_archetypes[v.archetype].role_definitions
      parent_id              = v.parent_id
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_5), v.parent_id)
  }
}
