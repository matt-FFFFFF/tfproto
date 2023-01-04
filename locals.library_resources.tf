locals {
  builtin_library_path = "${path.root}/lib"
}



locals {
  policy_definitions_in_archetypes_list = distinct(flatten([
      [
        for k, v in local.resultant_archetypes : v.policy_definitions
      ]
    ]
  ))

  builtin_policy_definitions_file_list = length(local.policy_definitions_in_archetypes_list) > 0 ? tolist(fileset(local.builtin_library_path, "**/policy_definition_*.json")) : []

  builtin_policy_definitions_data = [
    for f in local.builtin_policy_definitions_file_list : jsondecode(file("${local.builtin_library_path}/${f}"))
  ]

  resultant_policy_definitions_map = {
    for d in local.builtin_policy_definitions_data : d.name => d if contains(local.policy_definitions_in_archetypes_list, d.name)
  }
}
