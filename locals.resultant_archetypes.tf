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
          for pa in v.policy_definitions : pa if try(!contains(var.default_archetype_changes[k].policy_definition_exclusions, pa), true)
        ],
        try(var.default_archetype_changes[k].policy_definition_inclusions, [])
      ]))

      policy_set_definitions = distinct(flatten([
        [
          for pa in v.policy_set_definitions : pa if try(!contains(var.default_archetype_changes[k].policy_set_definition_exclusions, pa), true)
        ],
        try(var.default_archetype_changes[k].policy_set_definition_inclusions, [])
      ]))

      role_assignments = distinct(flatten([
        [
          for pa in v.role_assignments : pa if try(!contains(var.default_archetype_changes[k].role_assignment_exclusions, pa), true)
        ],
        try(var.default_archetype_changes[k].role_assignment_inclusions, [])
      ]))

      role_definitions = distinct(flatten([
        [
          for pa in v.role_definitions : pa if try(!contains(var.default_archetype_changes[k].role_definition_exclusions, pa), true)
        ],
        try(var.default_archetype_changes[k].role_definition_inclusions, [])
      ]))
    }
  },
  var.custom_archetypes)
}
