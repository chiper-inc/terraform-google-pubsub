
# Get the current GCP project
data "google_project" "project" {
}

locals {
  seven_days_in_seconds        = "604800s"
  default_ack_deadline_seconds = 30
  pubsub_svc_account_email     = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

Adds the Token Creator role to pubsub service account
Then the push subscriber can use authentication
resource "google_project_iam_member" "token_creator_binding" {
  project = data.google_project.project.id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${local.pubsub_svc_account_email}"
  depends_on = [
    google_pubsub_subscription.push_subscription,
  ]
}

resource "google_pubsub_topic_iam_member" "push_topic_binding" {
  project = data.google_project.project.id
  role    = "roles/pubsub.publisher"
  topic   = google_pubsub_topic.dlq.id
  member  = "serviceAccount:${local.pubsub_svc_account_email}"
  depends_on = [
    google_pubsub_topic.topic,
  ]
}

resource "google_pubsub_subscription_iam_member" "push_subscription_binding" {
  project      = data.google_project.project.id
  subscription = google_pubsub_subscription.push_subscription.id
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${local.pubsub_svc_account_email}"
  depends_on = [
    google_pubsub_subscription.push_subscription,
  ]
}

resource "google_pubsub_topic" "topic" {
  name                       = var.name
  labels                     = var.labels
  message_retention_duration = "86600s"
}

resource "google_pubsub_topic" "dlq" {
  name                       = "${var.name}-dlq"
  labels                     = var.labels
  message_retention_duration = "86600s"
}

resource "google_pubsub_subscription" "push_subscription" {

  name                       = "${var.name}-sub"
  topic                      = google_pubsub_topic.topic.id
  labels                     = var.labels
  ack_deadline_seconds       = 30
  message_retention_duration = local.seven_days_in_seconds
  retain_acked_messages      = false
  enable_message_ordering    = true

  push_config {
    push_endpoint = var.push_endpoint
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dlq.id
    max_delivery_attempts = 5
  }

}
