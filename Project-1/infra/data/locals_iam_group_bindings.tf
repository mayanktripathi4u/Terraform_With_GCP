
locals {
  file_path = "${path.module}/configs/iam_role_bindings"

  file_name = "${var.PROJECT_ENV}_${var.instance}_iam_group_bindings.yaml"

  # iam_bindings = yamldecode(file(local.file_name))
  # cf_config = trimsuffix(basename(file_name), ".yaml") => yamldecode(templatefile("${local.file_path}/${file_name}", {
  #   PROJECT_ID = var.project_id
  # }))

  cf_config = yamldecode(templatefile("${local.file_path}/${local.file_name}", {
    PROJECT_ID = var.project_id
  }))

  # # Filter only the project that matches the var.project_id
  # filtered_projects = [
  #   for project in local.iam_bindings["projects"] : project
  #   if project.name == var.project_id
  # ]

  # # Create a flattened list of bindings with each role expanded individually
  # flattened_iam_bindings = flatten([
  #   for project in local.filtered_projects : [
  #     for binding in project.bindings : [
  #       for role in binding.roles : {
  #         project   = project.name
  #         role      = role
  #         principal = binding.principal
  #       }
  #     ]
  #   ]
  # ])
}

output "file_name" {
  value = local.file_name
}

# output "file_content" {
#   # value = file("${local.file_name}")
#   value = file(local.file_name)
# }

# output "iam_bindings" {
#   value = local.iam_bindings
# }

# output "cf_config_output" {
#   value = local.cf_config
# }

# output "specific_cf_config_value" {
#   value = local.cf_config["projects"]
# }

# output "project_bindings" {
#   value = {
#     for project in local.cf_config["projects"] : project["name"] => [
#       for binding in project["bindings"] : {
#         principal = binding["principal"]
#         roles     = binding["roles"]
#       }
#     ]
#   }
# }