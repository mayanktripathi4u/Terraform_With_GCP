# Base GCP Variable
variable "project_id" {
  description = "The project in which the resourve belongs."
  type = string
}

# Base IAM Variables
variable "entity_type" {
  description = <<EOF
  Type of entity or resource to which IAM Bindings will be assigned.
  Supported entity_type are:
   - project
   - xx (TBD)
  EOF
  type = string
  validation {
    condition = contains([
        "project",
        "pubsub_topic",
        "TBD"
    ], var.entity_type)
    error_message = "Supported entity_types include: project, pubsub_topic, TBD"
  }
}

variable "entity_region" {
  description = <<INFO
   Region of resource targeted for IAM permission assignment. Region is only required for some entity types including:
    `cloud_run`
    `subnet`
  INFO
  type = string
  default = null
}

variable "entities" {
  description = <<INFO
   List of existing resources on which IAM Permissions will be assigned.
   The value that needs to be provided depends on the entity type. 
   Most of IAM Bindings will accept the resource's "name" value and those that don't are listed below.
    -- bigquery_datasets: requires `dataset_id`
    -- secret: requires `secret_id`
  INFO
  type = list(string)
  default = []
}

variable "bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies / bindings"
  type = map(list(string))
  default = {}
}

variable "bindings_by_principal" {
  description = <<INFO
   Map of principal (key) and list of roles (value) to add the IAM policies / bindings. This variable is not intended for commom use and should only be used with entity_type 'project'
  INFO
  type = map(list(string))
  default = {}
}

variable "conditional_bindings" {
  description = "List of maps of role, conditions, and the members to add the IAM policies / bindings"
  type = list(object({
    role = string
    title = string
    description =string
    expression = string
    members = list(string)
  }))
  default = []
}

variable "mode" {
  description = "Mode for adding the IAM policies / bindings, additive and authoritative"
  type = string
  default = "additive"
}