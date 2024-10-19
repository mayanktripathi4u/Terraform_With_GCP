variable "project_id" {
  type        = string
  description = "Project to work on"
  # default     = "budgetdatabase-395201"
  default = "gcphde-sec-dev-data"
}

variable "gcp_region" {
  type        = string
  description = "Region to Use in GCP"
  default     = "us-central1"
}

variable "PROJECT_ENV" {
  type        = string
  description = "Env. variable mostly use in Cloud Function. Example : dev; prod; synth; stage"
  default     = "dev"
}

# variable "iam_role_binding_file" {
#   type        = string
#   description = "IAM Role Binding File, to be determine internally."
# }

variable "instance" {
  type        = string
  description = "Instance - Primary (prim) or Secondary (seco)."
}

variable "mode" {
  type        = string
  default     = "additive"
  description = "Mode as additive for IAM Role Binding."
}
