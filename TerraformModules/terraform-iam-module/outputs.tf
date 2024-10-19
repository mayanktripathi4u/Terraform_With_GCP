output "bindings_by_member" {
  description = "List of bindings for entities unwinded by members"
  value = local.bindings_by_member
}

output "set_authoritative" {
  description = "A set of authoritative binding keys"
  value = local.set_authoritative
}


output "set_additive" {
  description = "A set of additive binding keys"
  value = local.set_additive
}

 