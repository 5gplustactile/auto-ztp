data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }
    resources = [aws_sns_topic.budgets_topic.arn]
    sid       = "AllowBudgetsToNotifySNSTopic"
  }
}

resource "aws_sns_topic" "budgets_topic" {
  name = "sns_budget_topic_${var.tagkeyvalue}"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.budgets_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
