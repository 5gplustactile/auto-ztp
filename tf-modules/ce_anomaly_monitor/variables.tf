variable "cost_threshold" {
  description = "Defines the amount in the account currency before AWS sends an email to the subscriber(s) that an anomaly was detected."
  type        = number
}

variable "enable_cost_anomaly_detection" {
  description = "Boolean to enable or disable Cost Explorer Anomaly Detection monitor and subscription."
  type        = bool
  default     = true
}

variable "subscription_email" {
  description = "This is the email address that gets notified when an anomaly is detected."
  type        = string
}

variable "tagkey" {
  type        = string
  description = "Tag key for filter"
}

variable "tagkeyvalue" {
  type        = string
  description = "Tag key value for filter"
}
