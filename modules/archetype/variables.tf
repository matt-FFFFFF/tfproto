variable "management_group_name" {
  type = string
}

variable "management_group_display_name" {
  type    = string
  default = ""
}

variable "management_group_parent_id" {
  type = string
}

variable "policy_definitions" {
  type = map(object({
    mode         = string
    display_name = string
    description  = optional(string, "")
    policy_rule  = string
    metadata     = string
    parameters   = string
  }))
  default = {}
}

variable "policy_set_definitions" {
  type = map(object({
    display_name = string
    description  = optional(string, "")
    metadata     = string
    parameters   = string
    policy_definition_references = list(object({
      policy_definition_id           = string
      policy_definition_reference_id = optional(string, "")
      parameters                     = optional(string, "")
    }))
  }))
  default = {}
}

variable "role_definitions" {
  type = map(object({
    description      = optional(string, "")
    actions          = optional(list(string), [])
    not_actions      = optional(list(string), [])
    data_actions     = optional(list(string), [])
    not_data_actions = optional(list(string), [])
  }))
  default = {}
}

variable "role_assignments" {
  type = map(object({
    principal_ids                       = list(string)
    role_definition_management_group_id = optional(string, "")
  }))
  default = {}
}

variable "policy_assignments" {
  type = map(object({
    policy_definition_id = string
    display_name         = string

    description          = optional(string, null)
    enforcement_mode     = optional(string, null)
    identity_resource_id = optional(string, null)
    identity_type        = optional(string, null)
    metadata             = optional(string, null)
    parameters           = optional(string, null)
  }))
  default = {}
}

variable "policy_assignments_role_assignment_data" {
  type = map(
    map(
      map(
        list(string)
      )
    )
  )
  default = {}
  description = <<DESCRIPTION
This data structure is used to create the role assignments required for the Azure Policy assignments.
The data should be in this format:

```hcl
{
  policy_definition_data = {
    # this is the azure resource name of the policy definition, not the display name
    <policy_definition_name> = {
      role_definition_ids = []
      additional_scopes = []
    }
  }
  policy_set_definition_data = {
    # this is the azure resource name of the policy set definition, not the display name
    <policy_set_definition_name> = {
      role_definition_ids = []
      additional_scopes = []
    }
  }
}
```

The module will then lookup the name of the policy or policy set referenced in the assignment and create the role assignments for the role definition ids specified.
It will create the assignments at the scope of the policy assignment and any additional scopes specified.
DESCRIPTION
}
