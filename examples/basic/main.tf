provider "google" {
  region  = "us-central1"
  project = terraform.workspace
}

module "pubsub" {
  source        = "../.."
  name          = "terraform-topic"

  push_subscriptions = [{
    name = "terraform-topic-sub"
    endpoint = "https://d600-189-38-151-229.ngrok.io/sub"
  }]

  labels = {
    "team": "arquitetura"
  }
}
