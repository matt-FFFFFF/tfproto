locals {
  # Resultant archetypes is a the map of archetypes that calculated after merging
  # the default archetypes with the requested changes, then merging with the custom archetypes.
  # Custom archetypes take precedence over default archetypes if the map keys are the same.
  resultant_archetypes = merge({
    for k, v in local.default_archetypes : k => {

      policy_assignments = distinct(flatten([
        [
          for pa in v.policy_assignments : pa if try(!contains(var.default_archetype_changes[k].policy_assignment_exclusions, pa), true)
        ],
        try(var.default_archetype_changes[k].policy_assignment_inclusions, [])
      ]))

      policy_definitions = distinct(flatten([
        [
          for pd in v.policy_definitions : pd if try(!contains(var.default_archetype_changes[k].policy_definition_exclusions, pd), true)
        ],
        try(var.default_archetype_changes[k].policy_definition_inclusions, [])
      ]))

      policy_set_definitions = distinct(flatten([
        [
          for psd in v.policy_set_definitions : psd if try(!contains(var.default_archetype_changes[k].policy_set_definition_exclusions, psd), true)
        ],
        try(var.default_archetype_changes[k].policy_set_definition_inclusions, [])
      ]))

      role_assignments = distinct(flatten([
        [
          for ra in v.role_assignments : ra if try(!contains(var.default_archetype_changes[k].role_assignment_exclusions, ra), true)
        ],
        try(var.default_archetype_changes[k].role_assignment_inclusions, [])
      ]))

      role_definitions = distinct(flatten([
        [
          for rd in v.role_definitions : rd if try(!contains(var.default_archetype_changes[k].role_definition_exclusions, rd), true)
        ],
        try(var.default_archetype_changes[k].role_definition_inclusions, [])
      ]))
    }
    },
  var.custom_archetypes)

  # This map is used to look up the key of var.deployed_archetypes (the management group id) for a given archetype name
  archetype_name_to_deployed_archetype = transpose({
    for k, v in var.archetypes_deployed : k => [v.archetype]
  })
}
