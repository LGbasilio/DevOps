resource "google_storage_bucket" "buckettfstat" {
  name          = "tfstate-loyal-road-353919-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
      }
}