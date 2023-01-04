output "resultant_archetypes" {
  value = {
    for k in sort(keys(local.resultant_archetypes)) : k => local.resultant_archetypes[k]
  }
}

output "archetypes_deployed_level_1" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_1)) : k => local.archetypes_deployed_level_1[k]
  }
}

output "archetypes_deployed_level_2" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_2)) : k => local.archetypes_deployed_level_2[k]
  }
}

output "archetypes_deployed_level_3" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_3)) : k => local.archetypes_deployed_level_3[k]
  }
}

output "archetypes_deployed_level_4" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_4)) : k => local.archetypes_deployed_level_4[k]
  }
}

output "archetypes_deployed_level_5" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_5)) : k => local.archetypes_deployed_level_5[k]
  }
}

output "archetypes_deployed_level_6" {
  value = {
    for k in sort(keys(local.archetypes_deployed_level_6)) : k => local.archetypes_deployed_level_6[k]
  }
}

output "params" {
  value = jsonencode({ for k, v in var.policy_parameters : k => {
    for k2, v2 in v : k2 => {
      value = v2
    }
  }})
}
