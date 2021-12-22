resource "google_pubsub_topic" "topic" {
  name = var.topic

  labels = {
    team = "arquitetura"
  }

  message_retention_duration = "86600s"
}
