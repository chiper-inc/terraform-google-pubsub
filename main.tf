
# Get the current GCP project
data "google_project" "project" {
}

# Default values
locals {
  message_retention_duration   = "604800s"
  default_message_ordering     = true
  default_ack_deadline_seconds = 30
  pubsub_svc_account_email     = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

# Adds the Token Creator role to pubsub service account
# Then the push subscriber can use authentication
resource "google_project_iam_member" "token_creator_binding" {

  project = data.google_project.project.id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${local.pubsub_svc_account_email}"
  depends_on = [
    google_pubsub_subscription.push_subscriptions,
  ]
}

resource "google_pubsub_topic_iam_member" "publisher_role" {
  project = data.google_project.project.project_id
  role    = "roles/pubsub.publisher"
  topic   = google_pubsub_topic.dlq.id
  member  = "serviceAccount:${local.pubsub_svc_account_email}"
  depends_on = [
    google_pubsub_topic.topic,
  ]
}

resource "google_pubsub_subscription_iam_member" "subscriber_role" {
  for_each = { for i in var.push_subscriptions : i.name => i }

  project      = data.google_project.project.project_id
  subscription = each.value.name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${local.pubsub_svc_account_email}"
  depends_on = [
    google_pubsub_subscription.push_subscriptions,
  ]
}

###
# TOPICS
###

resource "google_pubsub_topic" "topic" {
  name                       = var.name
  labels                     = var.labels
  message_retention_duration = local.message_retention_duration
}

resource "google_pubsub_topic" "dlq" {
  name                       = "${var.name}-dlq"
  labels                     = var.labels
  message_retention_duration = local.message_retention_duration
}

## 
# Subscriptions 

resource "google_pubsub_subscription" "push_subscriptions" {
  for_each = { for i in var.push_subscriptions : i.name => i }

  name                       = each.value.name
  topic                      = google_pubsub_topic.topic.id
  labels                     = var.labels
  ack_deadline_seconds       = local.default_ack_deadline_seconds
  message_retention_duration = local.message_retention_duration
  retain_acked_messages      = false
  enable_message_ordering    = local.default_message_ordering

  push_config {
    push_endpoint = each.value["endpoint"]
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
