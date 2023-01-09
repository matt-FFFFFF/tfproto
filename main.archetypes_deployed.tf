module "archetypes_level_1" {
  source                        = "./modules/archetype"
  for_each                      = local.archetypes_deployed_level_1
  management_group_name         = each.key
  management_group_parent_id    = "/providers/Microsoft.Management/managementGroups/${each.value.parent_id}"
  management_group_display_name = each.value.display_name

  policy_definitions     = each.value.policy_definitions
  policy_set_definitions = each.value.policy_set_definitions
  role_definitions       = each.value.role_definitions
  role_assignments       = each.value.role_assignments
}

module "archetypes_level_2" {
  source                        = "./modules/archetype"
  for_each                      = local.archetypes_deployed_level_2
  management_group_name         = each.key
  management_group_parent_id    = "/providers/Microsoft.Management/managementGroups/${each.value.parent_id}"
  management_group_display_name = each.value.display_name

  policy_definitions     = each.value.policy_definitions
  policy_set_definitions = each.value.policy_set_definitions
  role_definitions       = each.value.role_definitions
  role_assignments       = each.value.role_assignments

  depends_on = [
    module.archetypes_level_1
  ]
}

module "archetypes_level_3" {
  source                        = "./modules/archetype"
  for_each                      = local.archetypes_deployed_level_3
  management_group_name         = each.key
  management_group_parent_id    = "/providers/Microsoft.Management/managementGroups/${each.value.parent_id}"
  management_group_display_name = each.value.display_name

  policy_definitions     = each.value.policy_definitions
  policy_set_definitions = each.value.policy_set_definitions
  role_definitions       = each.value.role_definitions
  role_assignments       = each.value.role_assignments

  depends_on = [
    module.archetypes_level_2
  ]
}

module "archetypes_level_4" {
  source                        = "./modules/archetype"
  for_each                      = local.archetypes_deployed_level_4
  management_group_name         = each.key
  management_group_parent_id    = "/providers/Microsoft.Management/managementGroups/${each.value.parent_id}"
  management_group_display_name = each.value.display_name

  policy_definitions     = each.value.policy_definitions
  policy_set_definitions = each.value.policy_set_definitions
  role_definitions       = each.value.role_definitions
  role_assignments       = each.value.role_assignments

  depends_on = [
    module.archetypes_level_3
  ]
}

module "archetypes_level_5" {
  source                        = "./modules/archetype"
  for_each                      = local.archetypes_deployed_level_5
  management_group_name         = each.key
  management_group_parent_id    = "/providers/Microsoft.Management/managementGroups/${each.value.parent_id}"
  management_group_display_name = each.value.display_name

  policy_definitions     = each.value.policy_definitions
  policy_set_definitions = each.value.policy_set_definitions
  role_definitions       = each.value.role_definitions
  role_assignments       = each.value.role_assignments

  depends_on = [
    module.archetypes_level_4
  ]
}

module "archetypes_level_6" {
  source                        = "./modules/archetype"
  for_each                      = local.archetypes_deployed_level_6
  management_group_name         = each.key
  management_group_parent_id    = "/providers/Microsoft.Management/managementGroups/${each.value.parent_id}"
  management_group_display_name = each.value.display_name

  policy_definitions     = each.value.policy_definitions
  policy_set_definitions = each.value.policy_set_definitions
  role_definitions       = each.value.role_definitions
  role_assignments       = each.value.role_assignments

  depends_on = [
    module.archetypes_level_5
  ]
}
