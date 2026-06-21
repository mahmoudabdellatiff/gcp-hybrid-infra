terraform {
  backend "gcs" {
    bucket = "terraform-dev-gcp-2026-tfstate"
    prefix = "terraform/state"
  }
}
