locals {
  role_assignment_list = flatten([
    for k, v in var.role_assignments :
    [
      for id in v.principal_ids : {
        role_definition_management_group_id = v.role_definition_management_group_id
        role_definition_name                = k
        principal_id                        = id
      }
    ]
  ])
  role_assignment_map = {
    for ra in local.role_assignment_list : "${ra.role_definition_name}/${ra.principal_id}" => {
      role_definition_management_group_id = ra.role_definition_management_group_id
      role_definition_id                  = try(uuidv5("url", ra.role_definition_name), null)
      role_definition_name                = ra.role_definition_name
      principal_id                        = ra.principal_id
    }
  }
}
