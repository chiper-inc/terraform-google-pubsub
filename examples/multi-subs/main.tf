
module "pubsub" {
  source        = "../.."
  name          = "example-multi-topic"

  push_subscriptions = [{
    name = "example-multi-topic-one"
    endpoint = "https://d600-189-38-151-229.ngrok.io/sub"
  },{
    name = "example-multi-topic-two"
    endpoint = "https://d600-189-38-151-229.ngrok.io/sub"
  }]

  labels = {
    "team": "arquitetura"
  }
}
