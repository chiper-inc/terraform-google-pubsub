
# CONTEXT DATA
data "google_project" "project" {
}

# LOCALS
locals {
  kebab_name = replace(replace(lower(var.name), " ", "-"), "_", "")
}

###
# TOPICS
###
resource "google_pubsub_topic" "topic" {
  name   = local.kebab_name
  labels = var.labels
}

resource "google_pubsub_topic" "dlq" {
  for_each = { for i in var.push_subscriptions : i.name => i }

  name   = "${each.key}-dlq"
  labels = var.labels
}

## 
# PUSH SUBSCRIPTIONS 
##
resource "google_pubsub_subscription" "push_subscriptions" {
  for_each = { for i in var.push_subscriptions : i.name => i }

  name                       = "${replace(replace(lower(each.key), " ", "-"), "_", "")}-sub"
  topic                      = google_pubsub_topic.topic.id
  labels                     = var.labels
  ack_deadline_seconds       = lookup(each.value, "ack_deadline_seconds", 30)
  message_retention_duration = lookup(each.value, "message_retention_duration", "604800s")
  retain_acked_messages      = false
  enable_message_ordering    = lookup(each.value, "enable_message_ordering", false)

  push_config {
    push_endpoint = each.value.endpoint
    attributes = {
      x-goog-version = "v1"
    }
    oidc_token {
      service_account_email = lookup(each.value, "service_account_email", "")
    }
  }

  retry_policy {
    minimum_backoff = lookup(each.value, "retry_minimum_backoff", "10s")
    maximum_backoff = lookup(each.value, "retry_maximum_backoff", "600s")
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dlq[each.key].id
    max_delivery_attempts = lookup(each.value, "delivery_attempts", 5)
  }

}
