resource "google_project_service" "compute_api" {
  project = google_project.project.project_name
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}