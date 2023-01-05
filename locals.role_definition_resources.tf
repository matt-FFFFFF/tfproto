# Read Role Definitions from local.default_role_definitions and var.custom_role_definitions and rationalize by comparing with the definitions referenced
# in the resultant archetypes.
locals {
  role_definitions_in_archetypes_list = distinct(flatten([
      [
        for k, v in local.resultant_archetypes : v.role_definitions
      ]
    ]
  ))

  combined_role_definitions_map = merge(local.default_role_definitions, var.custom_role_definitions)

  resultant_role_definitions_map = {
    for k, v in local.combined_role_definitions_map : k => v if contains(local.role_definitions_in_archetypes_list, k)
  }
}
