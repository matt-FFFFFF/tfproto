# Read library Policy Definitions and rationalize by comparing with the definitions referenced
# in the resultant archetypes.
locals {
  policy_definitions_in_archetypes_list = distinct(flatten([
      [
        for k, v in local.resultant_archetypes : v.policy_definitions
      ]
    ]
  ))

  custom_policy_definitions_file_list = length(local.policy_definitions_in_archetypes_list) > 0 ? tolist(fileset(local.module_library_path, "**/policy_definition_*.json")) : []

  custom_policy_definitions_data = [
    for f in local.custom_policy_definitions_file_list : jsondecode(file("${local.module_library_path}/${f}"))
  ]

  resultant_policy_definitions_map = {
    for d in local.custom_policy_definitions_data : d.name => d if contains(local.policy_definitions_in_archetypes_list, d.name)
  }
}
