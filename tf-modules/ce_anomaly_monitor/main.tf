resource "aws_ce_anomaly_monitor" "this" {
  count = var.enable_cost_anomaly_detection == true ? 1 : 0

  name         = "AnomalyDetected_is_greater_than_${var.cost_threshold}"
  monitor_type = "CUSTOM"

  monitor_specification = jsonencode({
    And            = null
    CostCategories = null
    Dimensions     = null
    Not            = null
    Or             = null

    Tags = {
      Key          = var.tagkey
      MatchOptions = null
      Values = [
        var.tagkeyvalue
      ]
    }
  })
}

resource "aws_ce_anomaly_subscription" "this" {
  count = var.enable_cost_anomaly_detection == true ? 1 : 0

  name             = "AnomalyDetected_is_greater_than_${var.cost_threshold}"
  monitor_arn_list = [aws_ce_anomaly_monitor.this[0].arn]
  frequency        = "IMMEDIATE"
  subscriber {
    address = var.subscription_email
    type    = "EMAIL"
  }
  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      values        = ["${var.cost_threshold}"]
      match_options = ["GREATER_THAN_OR_EQUAL"]
    }
  }
}
