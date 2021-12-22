provider "google" {
  region     = "us-central1"
  project = "chiper-poc"
}

module "pubsub" {
  source = "../.."
  topic = "terraform-topic"
}
