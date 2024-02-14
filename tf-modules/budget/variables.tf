variable "budget_name" {
  type        = string
  description = "Name of Cost Budget"
  default     = "AWS Cost Budget"
}


variable "limit_amount" {
  type        = number
  description = "The budget limit amount"
}

variable "limit_unit" {
  type        = string
  description = "The budget limit unit. Default is USD"
  default     = "USD"
}

variable "direct_subscriber_email_addresses" {
  type        = list(string)
  description = "The list of email addresses of direct notification subscribers. This bypasses SNS Topic"
  default     = []
}

variable "time_period_start" {
  type        = string
  description = "The start of the time period covered by the budget"
  default     = "2017-07-01_00:00"
}

variable "time_period_end" {
  type        = string
  description = "The end of the time period covered by the budget"
  default     = "2087-06-15_00:00"
}

variable "time_unit" {
  type        = string
  description = "The length of time until a budget resets the actual and forecasted spend. Valid values: MONTHLY, QUARTERLY, ANNUALLY"
  default     = "MONTHLY"
}

variable "comparison_operator" {
  type        = string
  description = "Comparison operator to use to evaluate the condition. Can be LESS_THAN, EQUAL_TO or GREATER_THAN"
  default     = "GREATER_THAN"
}

variable "threshold" {
  type        = number
  description = "Threshold when the notification should be sent"
  default     = 100
}

variable "threshold_type" {
  type        = string
  description = "What kind of threshold is defined. Can be PERCENTAGE OR ABSOLUTE_VALUE"
  default     = "PERCENTAGE"
}

variable "notification_type" {
  type        = string
  description = "What kind of budget value to notify on. Can be ACTUAL or FORECASTED"
  default     = "FORECASTED"
}

variable "tagkey" {
  type        = string
  description = "Tag key for filter"
}

variable "tagkeyvalue" {
  type        = string
  description = "Tag key value for filter"
}
