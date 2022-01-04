# ------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ------------------------------------------------------------

variable "name" {
  description = "The name of the PubSub Topic."
  type        = string
}

variable "labels" {
  description = "Labels"
  type        = map(string)
}

variable "push_subscriptions" {
  description = "Push Subcriptions List"
  type = list(map(string))
}
