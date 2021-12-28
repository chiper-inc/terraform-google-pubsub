provider "google" {
  region  = "us-central1"
  project = terraform.workspace
}

terraform {
  backend "gcs" {
    bucket  = "terraform-chiper-poc"
    prefix  = "terraform/state"
  }
}

module "pubsub" {
  source        = "../.."
  name          = "terraform-topic"
  push_endpoint = "https://d600-189-38-151-229.ngrok.io/sub"
  labels = {
    "team": "arquitetura"
  }
}
