resource "aws_budgets_budget" "services_utilization" {
  name              = var.budget_name
  budget_type       = "COST"
  limit_amount      = var.limit_amount
  limit_unit        = var.limit_unit
  time_period_start = var.time_period_start
  time_unit         = var.time_unit

  cost_filter {
    name   = "TagKeyValue"
    values = ["${var.tagkey}${"$"}${var.tagkeyvalue}"]

  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "90"
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.direct_subscriber_email_addresses
    subscriber_sns_topic_arns  = [aws_sns_topic.budgets_topic.arn]
  }
}
