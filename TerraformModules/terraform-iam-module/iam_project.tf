# Project IAM Binding Authoritative
resource "google_project_iam_binding" "authoritative" {
#   provider = google
  for_each = alltrue([var.entity_type == "project", var.mode == "authoritative"]) ? local.set_authoritative : []
  project = local.bindings_authoritative[each.key].name
  role = local.bindings_authoritative[each.key].role
  members = local.bindings_authoritative[each.key].members
  dynamic "condition" {
    for_each = local.bindings_authoritative[each.key].condition.title == "" ? [] : [local.bindings_authoritative[each.key].condition]
    content {
        title = local.bindings_authoritative[each.key].condition.title
        description = local.bindings_authoritative[each.key].condition.description
        expression = local.bindings_authoritative[each.key].condition.expression
    }
  }
}

# Project IAM Binding Additive
resource "google_project_iam_member" "additive" {
#   provider = google
  for_each = alltrue([var.entity_type == "project", var.mode == "additive"]) ? local.set_additive : []
  project = local.bindings_additive[each.key].name
  role = local.bindings_additive[each.key].role
  member = local.bindings_additive[each.key].member
  dynamic "condition" {
    for_each = local.bindings_additive[each.key].condition.title == "" ? [] : [local.bindings_additive[each.key].condition]
    content {
        title = local.bindings_additive[each.key].condition.title
        description = local.bindings_additive[each.key].condition.description
        expression = local.bindings_additive[each.key].condition.expression
    }
  }
}