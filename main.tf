
# CONTEXT DATA
data "google_project" "project" {
}

# LOCAL VALUES
locals {
  message_retention_duration   = "604800s"
  default_message_ordering     = true
  default_ack_deadline_seconds = 30
  pubsub_svc_account_email     = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
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
# PUSH SUBSCRIPTIONS 
##
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
    oidc_token {
      service_account_email = each.value["service_account"]
    }
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
