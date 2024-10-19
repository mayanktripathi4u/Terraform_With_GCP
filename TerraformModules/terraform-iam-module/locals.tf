locals {
  # Set the Permission Mode; additive is default and should almost always be used
  authoritative = var.mode == "authoritative"
  additive = var.mode == "additive"

  # When there is only one entity we'll use the for-each instance name as 'default'
  aliased_entities = length(var.entities) == 1 ? ["default"] : var.entities

  # create list of bindings by role  
  bindings_by_role = distinct(flatten([
    for name in var.entities
    : [
        for role, members in var.bindings
        : {name = name, role = role, members = members, condition = { title = "", description = "", expression = "" } }
    ]
  ]))

  # Create list of bindings by principal
  bindings_by_principal = distinct(flatten([
    for name in var.entities
    : [
        for members, roles in var.bindings_by_principal
        : [
            for role in roles
            : { name = name, role = role, members = [members], condition = { title = "", description = "", expression = "" } }
        ]
    ]
  ]))

  # Create list of bindings by member; this is different than bindings_by_principal
  bindings_by_member = distinct(flatten([
    for binding in local.all_bindings 
    : [
        for member in binding["members"]
        : {name = binding["name"], role = binding["role"], member = member, condition = binding["condition"] }
    ]
  ]))

  # Create list of bindings by conditions
  bindings_by_conditions = distinct(flatten([
    for name in var.entities
    : [
        for binding in var.conditional_bindings
        : {name = name, role = binding.role, members = binding.members, condition = { title = binding.title, description = binding.description, expression = binding.expression}}
        ]
  ]))

  # Combine all bindings list into a single list
  all_bindings = concat(local.bindings_by_role, local.bindings_by_principal, local.bindings_by_conditions)

  # Create a list of authoritative keys
  keys_authoritative = distinct(flatten([
    for alias in local.aliased_entities
    : [
        for role in keys(var.bindings)
        : "${alias}--${role}"
    ]
  ]))

  # Create a list of authoritative keys for condition bindings
  keys_authoritative_conditional = distinct(flatten([
    for alias in local.aliased_entities
    : [
        for binding in var.conditional_bindings
        : "${alias}--${binding.role}--${binding.title}"
    ]
  ]))

  # Create a list of additive Keys
  keys_additive = distinct(flatten([
    for alias in local.aliased_entities
    : [
        for role, members in var.bindings
        : [
            for member in members
            : "${alias}--${role}--${member}"
        ]
    ]
  ]))

  # Create a list of additive keys for by principal bindings
  keys_additive_bindings_by_principal = distinct(flatten([
    for alias in local.aliased_entities
    : [
        for member, roles in var.bindings_by_principal
        : [
            for role in roles
            : "${alias}--${role}--${member}"
        ]
    ]
  ]))

  # Create a list of additive leys for conditional bindings
  keys_additive_conditional = distinct(flatten([
    for alias in local.aliased_entities
    : [
        for binding in var.conditional_bindings
        : [
            for member in binding.members
            : "${alias}--${binding.role}--${binding.title}--${member}"
        ]
    ]
  ]))

  # Combine all authoritative keys list into a single list
  all_keys_authoritative = concat(local.keys_authoritative, local.keys_authoritative_conditional)

  # Combine all additive keys list into a single list
  all_keys_additive = concat(local.keys_additive, local.keys_additive_bindings_by_principal, local.keys_additive_conditional)

  # COnvert list of authoritative keys into a set
  set_authoritative = (
    local.authoritative
    ? toset(local.all_keys_authoritative)
    : []
  )

  # COnvert list of additive keys into a set
  set_additive = (
    local.additive
    ? toset(local.all_keys_additive)
    : []
  )

  # Cretae a single map for authoritative keys and values lists
  bindings_authoritative = (
    local.authoritative
    ? zipmap(local.all_keys_authoritative, local.all_bindings)
    : {}
  )

  # Cretae a single map for additive keys and values lists
  bindings_additive = (
    local.additive
    ? zipmap(local.all_keys_additive, local.bindings_by_member)
    : {}
  )


}