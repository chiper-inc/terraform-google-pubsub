output "id" {
    value = google_pubsub_topic.topic.id
    description = "The id of the Pub/Sub topic"
}

output "name" {
    value = google_pubsub_topic.topic.name
    description = "The name of the Pub/Sub topic"
}

output "subscription_names" {
    value = { for k, v in google_pubsub_subscription.push_subscriptions : k => v.id }
    description = "The name list of Pub/Sub subscriptions"
}

output "dlqs" {
    value = { for k, v in google_pubsub_topic.dlq : k => v.id }
}
