variable "default_archetype_changes" {
  type = map(object({
    policy_assignment_inclusions     = optional(list(string), [])
    policy_assignment_exclusions     = optional(list(string), [])
    policy_definition_inclusions     = optional(list(string), [])
    policy_definition_exclusions     = optional(list(string), [])
    policy_set_definition_inclusions = optional(list(string), [])
    policy_set_definition_exclusions = optional(list(string), [])
    role_assignment_inclusions       = optional(list(string), [])
    role_assignment_exclusions       = optional(list(string), [])
    role_definition_inclusions       = optional(list(string), [])
    role_definition_exclusions       = optional(list(string), [])
  }))
  description = <<DESCRIPTION
Changes to be applied to the default archetypes (see `local.default_archetypes`).
Defined as a map of objects, where the key is the archetype name and the value is an object with the following properties:

- policy_assignment_inclusions: List of policy assignments to be included (added to) the archetype.
- policy_assignment_exclusions: List of policy assignments to be excluded (removed from) the archetype.
- policy_definition_inclusions: List of policy definitions to be included (added to) the archetype.
- policy_definition_exclusions: List of policy definitions to be excluded (removed from) the archetype.
- policy_set_definition_inclusions: List of policy set definitions to be included (added to) the archetype.
- policy_set_definition_exclusions: List of policy set definitions to be excluded (removed from) the archetype.
- role_assignment_inclusions: List of role assignments to be included (added to) the archetype.
- role_assignment_exclusions: List of role assignments to be excluded (removed from) the archetype.
- role_definition_inclusions: List of role definitions to be included (added to) the archetype.
- role_definition_exclusions: List of role definitions to be excluded (removed from) the archetype.
DESCRIPTION
  default     = {}
}

variable "custom_archetypes" {
  type = map(object({
    policy_assignments     = optional(list(string), [])
    policy_definitions     = optional(list(string), [])
    policy_set_definitions = optional(list(string), [])
    role_assignments       = optional(list(string), [])
    role_definitions       = optional(list(string), [])
  }))
  description = <<DESCRIPTION
Custom archetypes to be included in the configuration.
Defined as a map of objects, where the key is the archetype name and the value is an object with the following properties:

- policy_assignments: List of policy assignments to be included in the archetype.
- policy_definitions: List of policy definitions to be included in the archetype.
- policy_set_definitions: List of policy set definitions to be included in the archetype.
- role_assignments: List of role assignments to be included in the archetype.
- role_definitions: List of role definitions to be included in the archetype.
DESCRIPTION
  default     = {}
}

variable "custom_role_definitions" {
  type = map(object({
    description      = optional(string, "")
    actions          = optional(list(string), [])
    not_actions      = optional(list(string), [])
    data_actions     = optional(list(string), [])
    not_data_actions = optional(list(string), [])
  }))
  description = <<DESCRIPTION
Custom Role Definitions to be included in the configuration. These can be included in archetypes by referencing the map key.
Defined as a map of objects, where the key is the role name and the value is an object with the following properties:

- description: Longer form description of the role.
- actions: List of Azure actions that are allowed by the role.
- not_actions: List of Azure actions that are not allowed by the role.
- data_actions: List of Azure data actions that are allowed by the role.
- not_data_actions: List of Azure data actions that are not allowed by the role.
DESCRIPTION
  default     = {}
}

variable "archetypes_deployed" {
  type = map(object({
    parent_id                    = string
    display_name                 = optional(string, "")
    archetype                    = optional(string, "empty")
    policy_assignment_parameters = optional(map(any), {})
  }))
  default = {
    root = {
      archetype = "root"
      parent_id = ""
    }
    landing_zones = {
      archetype    = "landing_zones"
      display_name = "Landing Zones"
      parent_id    = "root"
    }
    connectivity = {
      archetype    = "connectivity"
      display_name = "Connectivity"
      parent_id    = "landing_zones"
    }
    management = {
      display_name = "Management"
      parent_id    = "landing_zones"
    }
    identity = {
      display_name = "Identity"
      parent_id    = "landing_zones"
    }
    sandboxes = {
      display_name = "Sandboxes"
      parent_id    = "root"
    }
    decomissioned = {
      display_name = "Decommissioned"
      parent_id    = "root"
    }
    corp = {
      archetype    = "corp"
      display_name = "Corp"
      parent_id    = "landing_zones"
    }
    online = {
      archetype    = "online"
      display_name = "Online"
      parent_id    = "landing_zones"
    }
    platform = {
      archetype    = "platform"
      display_name = "Platform"
      parent_id    = "root"
    }
  }
  validation {
    condition     = length(keys(var.archetypes_deployed)) > 0
    error_message = "At least one archetype must be defined."
  }

  validation {
    condition = anytrue(
      [for k, v in var.archetypes_deployed : v.parent_id == ""]
    )
    error_message = "At least one archetype must have a parent_id of \"\"."
  }
}

variable "root_parent_id" {
  type        = string
  description = <<DESCRIPTION
The parent management group id for the deployment.
If not supplied, the tenant root management group will be used.
DESCRIPTION
  default     = ""
}

variable "policy_parameters" {
  type = map(any)
  default = {
    "my_assignment" = {
      "my_parameter"  = ["my_value", "my_other_value"]
      "my_parameter2" = 2
      "my_parameter3" = true
      "my_parameter4" = "my_value"
    }
  }
}
