terraform {
  backend "gcs" {
    bucket  = "qwiklabs-gcp-00-90b1203a84f4"
    prefix  = "terraform/state"
	  }
depends_on = [google_storage_bucket.bucket_buckettfstat]
}