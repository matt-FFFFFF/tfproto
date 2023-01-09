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
