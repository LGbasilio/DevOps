resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-west4-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  resource "google_storage_bucket" "bucket-for-tfstate" {
  name        = "tfstate-loyal-road-353919"
  location    = "US"
  credentials = "loyal-road-353919-27ba2e9f8be1.json"
  uniform_bucket_level_access = true
}
terraform {
  backend "gcs" {
    bucket  = "tfstate-loyal-road-353919"
    prefix  = "terraform/state"
      }
}

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

