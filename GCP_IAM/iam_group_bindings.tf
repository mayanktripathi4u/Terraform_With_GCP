locals {
  iam_bindings = yamldecode(file(var.iam_config_file))

  # Filter only the project that matches the var.project_id
  filtered_projects = [
    for project in local.iam_bindings["projects"] : project
    if project.name == var.project_id
  ]

  # Create a flattened list of bindings with each role expanded individually
  flattened_iam_bindings = flatten([
    for project in local.filtered_projects : [
      for binding in project.bindings : [
        for role in binding.roles : {
          project   = project.name
          role      = role
          principal = binding.principal
        }
      ]
    ]
  ])
}

resource "google_project_iam_binding" "binding" {
  for_each = {
    for binding in local.flattened_iam_bindings :
    "${binding.project}-${binding.role}-${binding.principal}" => binding
  }

  project = each.value.project
  role    = each.value.role

  members = [each.value.principal]
}

output "output_iam_bindings" {
  value = local.iam_bindings
}

output "output_flattened_iam_bindings" {
  value = local.flattened_iam_bindings
}
