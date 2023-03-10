output "resultant_archetypes" {
  value = {
    for k in sort(keys(local.resultant_archetypes)) : k => local.resultant_archetypes[k]
  }
}

# output "combined_policy_definition_additional_scopes" {
#   value = local.combined_policy_definition_additional_scopes
# }

# output "zzz" {
#   value = { for k in sort(keys(local.combined_policy_set_role_definition_ids)) : k => local.combined_policy_set_role_definition_ids[k] }
# }

# output "archetype_name_to_deployed_archetype" {
#   value = {
#     for k in sort(keys(local.archetype_name_to_deployed_archetype)) : k => local.archetype_name_to_deployed_archetype[k]
#   }
# }

# output "resultant_role_definitions" {
#   value = {
#     for k in sort(keys(local.resultant_role_definitions_map)) : k => local.resultant_role_definitions_map[k]
#   }
# }

# output "resultant_policy_definitions" {
#   value = {
#     for k in sort(keys(local.resultant_policy_definitions_map)) : k => local.resultant_policy_definitions_map[k]
#   }
# }

# output "resultant_policy_set_definitions" {
#   value = {
#     for k in sort(keys(local.resultant_policy_set_definitions_map)) : k => local.resultant_policy_set_definitions_map[k]
#   }
# }

# output "resultant_policy_assignments" {
#   value = {
#     for k in sort(keys(local.resultant_policy_assignments_map)) : k => local.resultant_policy_assignments_map[k]
#   }
# }

# output "resultant_distinct_builtin_policy_definition_names" {
#   value = local.resultant_distinct_builtin_policy_definition_names
# }

output "archetypes_deployed_level_1" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_1)) : k => local.archetypes_deployed_level_1[k]
  }
}

output "archetypes_deployed_level_2" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_2)) : k => local.archetypes_deployed_level_2[k]
  }
}

output "archetypes_deployed_level_3" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_3)) : k => local.archetypes_deployed_level_3[k]
  }
}

output "archetypes_deployed_level_4" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_4)) : k => local.archetypes_deployed_level_4[k]
  }
}

output "archetypes_deployed_level_5" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_5)) : k => local.archetypes_deployed_level_5[k]
  }
}

output "archetypes_deployed_level_6" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_6)) : k => local.archetypes_deployed_level_6[k]
  }
}
