data "azurerm_client_config" "current" {}

module "archetypes_level_1" {
  source                        = "./modules/archetype"
  for_each                      = local.archetypes_deployed_level_1
  management_group_name         = each.key
  management_group_parent_id    = "/providers/Microsoft.Management/managementGroups/${each.value.parent_id}"
  management_group_display_name = each.value.display_name

  policy_definitions = each.value.policy_definitions
}
