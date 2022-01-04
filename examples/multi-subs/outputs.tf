output id {
    value = module.pubsub.name
}

output name {
    value = module.pubsub.name
}

output subscriptions {
    value = module.pubsub.subscription_names
}

output dlqs {
    value = module.pubsub.dlqs
}