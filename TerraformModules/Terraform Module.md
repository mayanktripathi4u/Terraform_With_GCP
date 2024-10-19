# Creating a reusable Terraform module
Creating a reusable Terraform module for managing GCP IAM resources in one directory and using it in another directory (or even from a different Git repository) can be achieved in a few steps. 

Here’s how to do it:

## Step 1: Create the Terraform Module for GCP IAM Resources
**Directory Structure for the Module:**
1. Create a directory for the IAM module, e.g., terraform-iam-module/.
2. Inside the directory, you will create the necessary Terraform files (main.tf, variables.tf, and outputs.tf).
```bash
terraform-iam-module/
├── main.tf
├── variables.tf
├── outputs.tf
```
Example: `main.tf`

Here’s an example of how you can define GCP IAM bindings in the main.tf file:

```bash
# main.tf

resource "google_project_iam_binding" "project_bindings" {
  for_each = var.role_bindings

  project = var.project_id
  role    = each.key
  members = each.value
}
```
* This will apply IAM bindings for a project.
* for_each: Loops over the role_bindings variable, which defines the roles and their members.

Example: `variables.tf`
Define the variables that the module will require:

```bash
# variables.tf

variable "project_id" {
  description = "The GCP project ID where the IAM roles will be applied."
  type        = string
}

variable "role_bindings" {
  description = "Map of role bindings to members. Key is the role, value is a list of members."
  type        = map(list(string))
}
```

Example: `outputs.tf`
Optionally, define outputs:

```bash
# outputs.tf

output "iam_roles_applied" {
  description = "Roles applied to the project."
  value       = var.role_bindings
}
```

## Step 2: Use the Module in Another Directory
Now that you have created your IAM module, you can reference this module from another directory or even a different Git repository.

**Example Usage in Another Directory:**

Create a new directory for your project, and inside it, you will define your main.tf to use the IAM module.

Directory Structure:
```bash
my-terraform-project/
├── main.tf
```
`main.tf`:
```bash
# main.tf

module "iam_bindings" {
  source     = "../terraform-iam-module"  # Local path to the module
  project_id = "your-project-id"

  role_bindings = {
    "roles/viewer" = [
      "user:example-user@example.com",
      "group:example-group@example.com"
    ]
    "roles/editor" = [
      "serviceAccount:example-sa@your-project-id.iam.gserviceaccount.com"
    ]
  }
}
```

* The source argument points to the location of your module.
    * In this case, source = "../terraform-iam-module" is using a relative path.
    * If the module is in a Git repository, you would use source = "git::https://github.com/your-repo/terraform-iam-module.git".
  * 

## Step 3: Use the Module from a Different Git Repository
If the module is hosted in a Git repository, reference it like this:

```bash
# main.tf

module "iam_bindings" {
  source     = "git::https://github.com/your-repo/terraform-iam-module.git"
  project_id = "your-project-id"

  role_bindings = {
    "roles/viewer" = [
      "user:example-user@example.com",
      "group:example-group@example.com"
    ]
    "roles/editor" = [
      "serviceAccount:example-sa@your-project-id.iam.gserviceaccount.com"
    ]
  }
}
```

## Step 4: Initialize and Apply
1. Initialize the working directory to download the module:
```bash
terraform init
```
Apply the Terraform configuration:

```bash
terraform apply
```

This will use the module and apply the IAM bindings to the GCP project as defined.

# Key Points:
* Modularization allows you to reuse IAM configuration across multiple projects.
* Modules can be local (in the same repo) or remote (in a Git repository).
* `source` determines where Terraform fetches the module from (local path or remote URL).
