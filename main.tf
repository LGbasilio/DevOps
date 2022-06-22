resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-west4-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}
resource "google_storage_bucket" "bucket-for-tfstate" {
  name        = "loyal-road-353919"
  location    = "US"
  uniform_bucket_level_access = true
}
terraform {
  backend "gcs" {
    bucket  = "loyal-road-353919"
    prefix  = "terraform/state"
      }
}

