terraform {
  backend "gcs" {
    prefix = "terraform-google-pubsub/examples/basic"
    bucket = "terraform-chiper-prod"
  }
}
