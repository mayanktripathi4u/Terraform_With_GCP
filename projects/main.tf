resource "google_project" "project" {
  name = var.project_name # "HRZ-PRJ-DEV-001"
  project_id = var.project_name  # "HRZ-PRJ-DEV-001"
#   folder_id = google_folder.mySubFolder.name  # alterbatively could provide the ID or Name directly.
    folder_id = "folders/${var.folder_id}"
}

