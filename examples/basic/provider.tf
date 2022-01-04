locals {
  workspaces = {
    dev = {
      gcp_project = "chiper-development"
    }
    stag = {
      gcp_project = "chiper-staging"
    }
    prod = {
      gcp_project = "dataflow-chiper"
    }
  }
}

provider "google" {
  region  = "us-central1"
  project = local.workspaces[terraform.workspace].gcp_project
}
