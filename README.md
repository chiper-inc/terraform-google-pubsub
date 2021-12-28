# Google PubSub Module

This repo contains a module for deploying a [PubSub Topic and Subscriptions][pubsub] on GCP using [Terraform][terraform]. PubSub is a service from GCP that allow appications comunicate asynchronously.

[terraform]: https://terraform.io
[pubsub]: https://cloud.google.com/pubsub/docs/overview

## How to use this Module

For basic usage you can includ this module as follows:

```
module "pubsub" {
  source        = "git@github.com:chiper-inc/terraform-google-pubsub.git?v1"
  name          = "terraform-topic"
  push_endpoint = "https://d600-189-38-151-229.ngrok.io/sub"
  labels = {
    "team": "arquitetura"
  }
}
```


## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such as a database or server cluster. Each Module is created using [Terraform][], and includes automated tests, examples, and documentation. It is maintained both by the open source community and companies that provide commercial support.

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, you can leverage the work of the Module community to pick up infrastructure improvements through a version number bump.

[terraform]: https://terraform.io

## Who maintains this Module?

This Module ins maintained by the Arcthecture Team. If you're looking for help or contribute, reach us by sending a message to slack channel #tecnologia.











gcloud auth application-default login

terraform init
terraform apply