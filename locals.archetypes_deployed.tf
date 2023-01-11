locals {
  # These locals represent the archetypes that are deployed to the tenant.
  # They are organized into 'levels' according to the parent_id of the archetype.
  # They contain all of the data that is required to deploy the archetype, with custom Azure resource data read from the library.

  archetypes_deployed_level_1 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments = {
        for k2, v2 in local.resultant_policy_assignments_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_assignments, k2)
      }
      policy_definitions = {
        for k2, v2 in local.resultant_policy_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_definitions, k2)
      }
      policy_set_definitions = {
        for k2, v2 in local.resultant_policy_set_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_set_definitions, k2)
      }
      role_assignments       = v.role_assignments
      role_definitions       = {
        for k2, v2 in local.resultant_role_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].role_definitions, k2)
      }
      parent_id              = coalesce(var.root_parent_id, data.azurerm_client_config.current.tenant_id)
      display_name           = v.display_name
    } if v.parent_id == ""
  }

  archetypes_deployed_level_2 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments = {
        for k2, v2 in local.resultant_policy_assignments_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_assignments, k2)
      }
      policy_definitions = {
        for k2, v2 in local.resultant_policy_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_definitions, k2)
      }
      policy_set_definitions = {
        for k2, v2 in local.resultant_policy_set_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_set_definitions, k2)
      }
      role_assignments       = v.role_assignments
      role_definitions       = {
        for k2, v2 in local.resultant_role_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].role_definitions, k2)
      }
      parent_id              = coalesce(var.root_parent_id, data.azurerm_client_config.current.tenant_id)
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_1), v.parent_id)
  }

  archetypes_deployed_level_3 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments = {
        for k2, v2 in local.resultant_policy_assignments_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_assignments, k2)
      }
      policy_definitions = {
        for k2, v2 in local.resultant_policy_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_definitions, k2)
      }
      policy_set_definitions = {
        for k2, v2 in local.resultant_policy_set_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_set_definitions, k2)
      }
      role_assignments       = v.role_assignments
      role_definitions       = {
        for k2, v2 in local.resultant_role_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].role_definitions, k2)
      }
      parent_id              = coalesce(var.root_parent_id, data.azurerm_client_config.current.tenant_id)
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_2), v.parent_id)
  }

  archetypes_deployed_level_4 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments = {
        for k2, v2 in local.resultant_policy_assignments_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_assignments, k2)
      }
      policy_definitions = {
        for k2, v2 in local.resultant_policy_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_definitions, k2)
      }
      policy_set_definitions = {
        for k2, v2 in local.resultant_policy_set_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_set_definitions, k2)
      }
      role_assignments       = v.role_assignments
      role_definitions       = {
        for k2, v2 in local.resultant_role_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].role_definitions, k2)
      }
      parent_id              = coalesce(var.root_parent_id, data.azurerm_client_config.current.tenant_id)
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_3), v.parent_id)
  }

  archetypes_deployed_level_5 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments = {
        for k2, v2 in local.resultant_policy_assignments_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_assignments, k2)
      }
      policy_definitions = {
        for k2, v2 in local.resultant_policy_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_definitions, k2)
      }
      policy_set_definitions = {
        for k2, v2 in local.resultant_policy_set_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_set_definitions, k2)
      }
      role_assignments       = v.role_assignments
      role_definitions       = {
        for k2, v2 in local.resultant_role_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].role_definitions, k2)
      }
      parent_id              = coalesce(var.root_parent_id, data.azurerm_client_config.current.tenant_id)
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_4), v.parent_id)
  }

  archetypes_deployed_level_6 = {
    for k, v in var.archetypes_deployed : k => {
      policy_assignments = {
        for k2, v2 in local.resultant_policy_assignments_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_assignments, k2)
      }
      policy_definitions = {
        for k2, v2 in local.resultant_policy_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_definitions, k2)
      }
      policy_set_definitions = {
        for k2, v2 in local.resultant_policy_set_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].policy_set_definitions, k2)
      }
      role_assignments       = v.role_assignments
      role_definitions       = {
        for k2, v2 in local.resultant_role_definitions_map : k2 => v2 if contains(local.resultant_archetypes[v.archetype].role_definitions, k2)
      }
      parent_id              = coalesce(var.root_parent_id, data.azurerm_client_config.current.tenant_id)
      display_name           = v.display_name
    } if contains(keys(local.archetypes_deployed_level_5), v.parent_id)
  }
}
