module "folders" {
  source = "./folders"
}

module "project" {
  source = "./projects"
  project_name = "HRZ-PRJ-DEV-001"
}

module "compute" {
  source = "./compute"
}