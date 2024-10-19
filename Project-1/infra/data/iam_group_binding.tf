
# module "iam_bindings" {
#   source     = "/Users/tripathimachine/Desktop/Apps/GitHub_Repo/Terraform_With_GCP/TerraformModules/terraform-iam-module" # Local path to the module
#   project_id = var.project_id
#   #   version = "~>1.0.0"
#   entity_type = "project"
#   entities    = [var.project_id]
#   mode        = "additive"
#   bindings_by_principal = {
#     "user:dousik.tripathi.tn@gmail.com" = [
#       "roles/bigquery.dataViewer",
#       "roles/viewer",
#       "roles/cloudfunctions.viewer",
#     ]
#   }
# }

module "iam_bindings" {
  source = "/Users/tripathimachine/Desktop/Apps/GitHub_Repo/Terraform_With_GCP/TerraformModules/terraform-iam-module" # Local path to the module

  for_each = {
    for project in local.cf_config["projects"] :
    project["name"] => project if project["name"] == var.project_id # Filter projects based on condition
  }

  project_id = var.project_id
  # project_id = each.value.projects.name
  #   version = "~>1.0.0"
  entity_type = "project"
  entities    = [var.project_id]
  mode        = var.mode
  bindings_by_principal = {
    for binding in each.value.bindings :
    binding["principal"] => binding["roles"]
  }
}


module "iam_bindings_conditional" {
  source = "/Users/tripathimachine/Desktop/Apps/GitHub_Repo/Terraform_With_GCP/TerraformModules/terraform-iam-module" # Local path to the module
  # for_each = local.cf_config["projects"]  
  # for_each = { for project in local.cf_config["projects"] : project["name"] => project } # Convert list to map                                                                              # Loop over each project

  for_each = {
    for project in local.cf_config["projects"] :
    project["name"] => project if project["name"] == var.project_id # Filter projects based on condition
  }

  project_id = var.project_id
  # project_id = each.value.projects.name
  #   version = "~>1.0.0"
  entity_type = "project"
  entities    = [var.project_id]
  mode        = var.mode
  # Conditional bindings handling
  conditional_bindings = [
    for cond in each.value.conditional :
    {
      role        = cond["roles"],
      title       = cond["title"],
      description = cond["description"],
      expression  = cond["expression"],
      members     = cond["members"]
    }
  ]
}

output "print_project" {
  value = var.project_id
}