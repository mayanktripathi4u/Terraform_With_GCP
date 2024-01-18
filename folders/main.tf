resource "google_folder" "myFolder" {
  display_name = "tf-test"
  parent = "organizations/<organization id>"
}

resource "google_folder" "mySubFolder" {
  display_name = "tf-sub-test"
  parent = "folders/{google_folder.myFolder.folder_id}"
}

