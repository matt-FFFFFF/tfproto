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
    name         = string
    mode         = string
    display_name = string
    description  = optional(string, "")
    policy_rule  = string
    metadata     = string
    parameters   = string
  }))
  default = {}
}
