# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the PubSub Topic."
  type        = string
}


variable "labels" {
  description = "Labels"
  type        = map(string)
}

variable "push_endpoint" {
  description = "Endpoint"
  type        = string
}
