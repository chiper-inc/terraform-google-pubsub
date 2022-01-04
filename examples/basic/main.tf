
module "pubsub" {
  source        = "../.."
  name          = "example-basic-topic"

  push_subscriptions = [{
    name = "example-basic-topic"
    endpoint = "https://d600-189-38-151-229.ngrok.io/sub"
  }]

  labels = {
    "team": "arquitetura"
  }
}
