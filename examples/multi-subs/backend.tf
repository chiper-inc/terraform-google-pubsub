terraform {
  backend "gcs" {
    prefix = "terraform-google-pubsub/examples/multi-subs"
    bucket = "terraform-chiper-prod"
  }
}
