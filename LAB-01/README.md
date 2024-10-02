# Terraform With GCP

In here we are building the GCP Infrastructure from scratch and will maintain using Terraform.

Note : Before starting with this, I already have 
1. A GCP Account.
2. Organization is created. (Make sure to replace the `organization id` with the actual value in file "`/folders/main.tf`".) 
3. Service Account is created, and for now grant "Editor" access.
4. Service Account credentials are saved in json format in `key.json`, which we are referring into our `provider.tf` file.

To start with this we will follow the modular structure. So lets create a folders as below.
    |
    |-- folders
    |   |-- main.tf
    |   |-- variable.tf
    |-- projects
    |-- networks   
    |-- compute
    |-- main.tf
    |-- provider.tf
    |-- key.json
    

To set the value for any of the parameter there are 3 ways.
1. Hard-Code the values.
2. Refer from Variable, for this define the value in `variable.tf` or pass during run-time.
3. Dynamically / Run-Time refer from other resource created. 

Example : 
Hard-Code values.
    resource "google_project" "project" {
    name = "HRZ-PRJ-DEV-001"
    project_id = "HRZ-PRJ-DEV-001"
    folder_id = "folders/123456789"
    }

Referring from variable.tf.
    resource "google_project" "project" {
    name = var.project_name
    project_id = var.project_name
    folder_id = var.folder_name
    }


Referring dynamically / run-time
    resource "google_project" "project" {
    name = "HRZ-PRJ-DEV-001"
    project_id = "HRZ-PRJ-DEV-001"
    folder_id = google_folder.mySubFolder.name 
    }